#!/bin/bash
set -e
REQUIREMENTS_FILE="$(pwd)/codacy/requirements.yaml"
OLD_LOCK_FILE="$(pwd)/codacy/requirements_old.lock"
NEW_LOCK_FILE="$(pwd)/codacy/requirements.lock"
CHANGELOG_FILE="$(pwd)/changelogs/changelog.md"

function appendToChangelog() {
    echo "$1" >> "$CHANGELOG_FILE"
}

function prepareEnvironment() {
    rm -rf ./changelogs
    mkdir changelogs
    prepareChangelogMarkdown
    git cat-file blob "latest":"codacy/requirements.lock" > "$OLD_LOCK_FILE"
    make -C ../ helm_dep_up
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
    appendToChangelog "## $project_name([$repository_url]())"
    changeset="$(gitchangelog $old_version $new_version)"
    appendToChangelog "$changeset"
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

function handleNewDependency() {
    echo "New dependency $1($2): $3"
    appendToChangelog "" # add blank line in changelog.md
    appendToChangelog "## $1([$2]())"
    appendToChangelog "### $3"
    appendToChangelog "* This dependency was introduced at this version."
    appendToChangelog "" # add blank line in changelog.md
}

echo "Getting changelogs..."
prepareEnvironment
echo "Resolving dependencies..."
dependencies=$(yq r "$NEW_LOCK_FILE" dependencies -j | jq -r ".[].name")
for dependency in $dependencies
do
    old_version=$(yq r $OLD_LOCK_FILE dependencies -j | jq -r ".[] | select(.name==\"$dependency\").version")
    new_version=$(yq r $NEW_LOCK_FILE dependencies -j | jq -r ".[] | select(.name==\"$dependency\").version")
    repository_url=$(yq r $REQUIREMENTS_FILE dependencies -j | jq -r ".[] | select(.name==\"$dependency\").git")

    if [ "$old_version" != "" ] && [ "$old_version" != "$new_version" ] && [ "$repository_url" != "null" ];
        then
            cloneRepository "$dependency" "$old_version" "$new_version" "$repository_url"
            getChangelog "$dependency" "$old_version" "$new_version" "$repository_url"
        else
            [ "$repository_url" == "null" ] && echo "Skipped $dependency: has no repository url."
            [ "$old_version" == "$new_version" ] && echo "Skipped $dependency: $old_version is the same as $new_version"
            [ "$old_version" == "" ] && handleNewDependency $dependency $repository_url $new_version
    fi
done

rm "$OLD_LOCK_FILE"
rm "$GITCHANGELOG_CONFIG_FILENAME"

exit 0
