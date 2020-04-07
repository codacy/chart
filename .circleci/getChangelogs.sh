#!/bin/bash
set -e
REQUIREMENTS_FILE="codacy/requirements.yaml"
OLD_LOCK_FILE="codacy/requirements_old.lock"
NEW_LOCK_FILE="codacy/requirements.lock"

function prepareChangelogMarkdown(){
    changelog_conf_path=$(realpath .)/.changelogs
    export GITCHANGELOG_CONFIG_FILENAME=$changelog_conf_path/gitchangelog.rc
    markdown_template_path=$(echo "$changelog_conf_path/markdown.tpl" | sed 's/\//\\\//g')
    sed "s/##PATHMACRO##/$markdown_template_path/g" "$changelog_conf_path/gitchangelogtemplate.rc" >> "$GITCHANGELOG_CONFIG_FILENAME"
    echo "# Codacy Chart Changelog" >> "changelogs/changelog.md"
}

function getChangelog() {
    project_name=$1
    old_version=$2
    new_version=$3
    repository_url=$4
    cd "$project_name"
    echo "  * $old_version -> $new_version"
    git fetch --all --quiet
    git checkout tags/"$old_version" --quiet
    echo "## $project_name($repository_url)" >> "../changelogs/changelog.md"
    gitchangelog "$old_version" "$new_version" >> "../changelogs/changelog.md"
    cd ..
    rm -rf "./$project_name"
}

function cloneRepository() {
    project_name=$1
    old_version=$2
    new_version=$3
    repository_url=$4
    echo "[OK] checking out: $project_name($repository_url)"
    git clone "$repository_url" "$project_name" --quiet
}

function getOldDependencyVersion(){
    old_version="$(getDependencyVersion \"$OLD_LOCK_FILE\" \"$1\")"
    if [ "$old_version" == "" ]; then
        # this means this dependency is new as there is no old_version as per the requirements file
        # therefore we fetch the oldest tag from the git remote
        old_version="$(git ls-remote --tags \"$2\" | sort -t '/' -k 3 -V | awk '{print $2}' | sed 's/refs\/tags\///g' | head -n 1)"
    fi
    echo "$old_version"
}

function getDependencies() {
    echo "$(yq r \"$1\" dependencies -j | jq -r \".[].name\")"
}

function getDependencyVersion() {
    echo "$(yq r \"$1\" dependencies -j | jq -r \".[] | select(.name==$2).version\")"
}

function getDependencyRepoUrl() {
    echo "$(yq r \"$1\" dependencies -j | jq -r \".[] | select(.name==$2).git\")"
}

rm -rf ./changelogs
mkdir changelogs
prepareChangelogMarkdown

LATEST_TAG="stable"
git cat-file blob "$LATEST_TAG":"$NEW_LOCK_FILE" > "$OLD_LOCK_FILE"
DEPENDENCIES=$(getDependencies $NEW_LOCK_FILE)

for key in $DEPENDENCIES
do
    repository_url="$(getDependencyRepoUrl \"$REQUIREMENTS_FILE\" \"$key\")"
    old_version="$(getOldDependencyVersion \"$key\" \"$repository_url\")"
    new_version="$(getDependencyVersion \"$NEW_LOCK_FILE\" \"$key\")"

    if [ "$old_version" != "$new_version" ] && [ "$repository_url" != "null" ];
        then
            cloneRepository "$key" "$old_version" "$new_version" "$repository_url"
            getChangelog "$key" "$old_version" "$new_version" "$repository_url"
        else
            echo "[Skipped] $key:"
            [ "$repository_url" == "null" ] && echo "  * has no repository url."
            [ "$old_version" == "$new_version" ] && echo "  * $old_version is the same as $new_version"
    fi
done

rm "$OLD_LOCK_FILE"
rm "$GITCHANGELOG_CONFIG_FILENAME"

exit 0
