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
    echo "# Codacy Chart Changelog" >> "../changelogs/changelog.md"
}

function getChangelog() {
    project_name=$1
    old_version=$2
    new_version=$3
    repository_url=$4
    echo " * getting changelog ..."
    cd "$project_name"
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
    echo "[OK] $project_name($repository_url) : $old_version -> $new_version"
    git clone "$repository_url" "$project_name" --quiet
}

rm -rf ./changelogs
mkdir changelogs
prepareChangelogMarkdown

LATEST_TAG="stable"
git cat-file blob "$LATEST_TAG":"$NEW_LOCK_FILE" > "$OLD_LOCK_FILE"
DEPENDENCIES=$(yq r $OLD_LOCK_FILE dependencies -j | jq ".[].name" | sed "s/\"//g")

for key in $DEPENDENCIES
do
    old_version=$(yq r $OLD_LOCK_FILE dependencies -j | jq ".[] | select(.name==\"$key\").version" | sed "s/\"//g")
    new_version=$(yq r $NEW_LOCK_FILE dependencies -j | jq ".[] | select(.name==\"$key\").version" | sed "s/\"//g")
    repository_url=$(yq r $REQUIREMENTS_FILE dependencies -j | jq ".[] | select(.name==\"$key\").git" | sed "s/\"//g")
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
