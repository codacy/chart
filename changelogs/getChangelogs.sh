#!/bin/bash
set -e
REQUIREMENTS_FILE="$(pwd)/codacy/requirements.yaml"
OLD_LOCK_FILE="$(pwd)/codacy/requirements_old.lock"
NEW_LOCK_FILE="$(pwd)/codacy/requirements.lock"
CHANGELOG_FILE="$(pwd)/release-notes-tools/changelog.md"
RELEASENOTES_FILE="$(pwd)/release-notes-tools/releasenotes.md"
MISSINGRELEASENOTES_FILE="$(pwd)/release-notes-tools/missingreleasenotes.md"

function appendToChangelog() {
    echo "$1" >> "$CHANGELOG_FILE"
}

function handleNewDependency() {
    echo "New dependency $1($2): $3"
    appendToChangelog "## $1([$2]())"
    appendToChangelog "### $3"
    appendToChangelog "* This dependency was introduced at this version."
    appendToChangelog "" # add blank line in changelog.md
}

git cat-file blob "latest":"codacy/requirements.lock" > "$OLD_LOCK_FILE"
dependencies=$(yq r "$NEW_LOCK_FILE" dependencies -j | jq -r ".[].name")
for dependency in $dependencies
do
    start_tag=$(yq r "$OLD_LOCK_FILE" dependencies -j | jq -r ".[] | select(.name==\"$dependency\").version")
    end_tag=$(yq r "$NEW_LOCK_FILE" dependencies -j | jq -r ".[] | select(.name==\"$dependency\").version")
    repository_url=$(yq r "$REQUIREMENTS_FILE" dependencies -j | jq -r ".[] | select(.name==\"$dependency\").git")

    if [ "$start_tag" != "" ] && [ "$start_tag" != "$end_tag" ] && [ "$repository_url" != "null" ];
        then
            cd release-notes-tools
            python3 jira-release-notes.py -u "$repository_url" -st "$start_tag" -et "$end_tag" --append-header --append-changelog --no-release-notes
            cd ..
        else
            [ "$repository_url" == "null" ] && echo "Skipped $dependency: has no repository url."
            [ "$start_tag" == "$end_tag" ] && echo "Skipped $dependency: $start_tag is the same as $end_tag"
            [ "$start_tag" == "" ] && handleNewDependency "$dependency" "$repository_url" "$end_tag"
    fi
done

cd release-notes-tools
python3 jira-release-notes.py -u "Codacy Chart" -st "" -et ""  --no-changelogs
cd ..

rm "$OLD_LOCK_FILE"
mv "$CHANGELOG_FILE" ./changelog.md
mv "$RELEASENOTES_FILE" ./docs/releasenotes.md
mv "$MISSINGRELEASENOTES_FILE" ./missingreleasenotes.md
