#!/bin/bash
set -e
REQUIREMENTS_FILE="codacy/requirements.yaml"
OLD_LOCK_FILE="codacy/requirements_old.lock"
NEW_LOCK_FILE="codacy/requirements.lock"
CHANGELOG_FILE="$(pwd)/changelogs/changelog.md"
LATEST_TAG="latest"

function appendToChangelog() {
    echo "$1" >> "$CHANGELOG_FILE"
}

function prepareEnvironment() {
    rm -rf ./changelogs
    mkdir changelogs
    prepareChangelogMarkdown
    git cat-file blob "$LATEST_TAG":"$NEW_LOCK_FILE" > "$OLD_LOCK_FILE"
}

function prepareChangelogMarkdown() {
    changelog_conf_path=$(realpath .)/.changelogs
    export GITCHANGELOG_CONFIG_FILENAME=$changelog_conf_path/gitchangelog.rc
    markdown_template_path=$(echo "$changelog_conf_path/markdown.tpl" | sed 's/\//\\\//g')
    sed "s/##PATHMACRO##/$markdown_template_path/g" "$changelog_conf_path/gitchangelogtemplate.rc" >> "$GITCHANGELOG_CONFIG_FILENAME"
    appendToChangelog "# Codacy Chart Changelog"
}

function getChangelog() {
    project_name=$1
    old_version=$2
    new_version=$3
    repository_url=$4
    cd "$project_name"
    echo "Getting changelog: $old_version -> $new_version"
    git fetch --all --quiet
    git checkout tags/"$old_version" --quiet
    appendToChangelog "## $project_name($repository_url)"
    appendToChangelog "$(gitchangelog \"$old_version\" \"$new_version\")"
    cd ..
    rm -rf "./$project_name"
}

function cloneRepository() {
    project_name=$1
    old_version=$2
    new_version=$3
    repository_url=$4
    echo "Checking out: $project_name($repository_url)"
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

prepareEnvironment
dependencies=$(yq r "$NEW_LOCK_FILE" dependencies -j | jq -r ".[].name")
for key in $dependencies
do
    old_version=$(yq r $OLD_LOCK_FILE dependencies -j | jq -r ".[] | select(.name==\"$key\").version")
    new_version=$(yq r $NEW_LOCK_FILE dependencies -j | jq -r ".[] | select(.name==\"$key\").version")
    repository_url=$(yq r $REQUIREMENTS_FILE dependencies -j | jq -r ".[] | select(.name==\"$key\").git")

    if [ "$old_version" != "$new_version" ] && [ "$repository_url" != "null" ];
        then
            cloneRepository "$key" "$old_version" "$new_version" "$repository_url"
            getChangelog "$key" "$old_version" "$new_version" "$repository_url"
        else
            [ "$repository_url" == "null" ] && echo "Skipped $key: has no repository url."
            [ "$old_version" == "$new_version" ] && echo "Skipped $key: $old_version is the same as $new_version"
    fi
done

rm "$OLD_LOCK_FILE"
rm "$GITCHANGELOG_CONFIG_FILENAME"

exit 0
