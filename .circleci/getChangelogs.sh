#!/bin/bash
set -e
REQUIREMENTS_FILE="codacy/requirements.yaml"
OLD_LOCK_FILE="codacy/requirements_old.lock"
NEW_LOCK_FILE="codacy/requirements.lock"

function getChangelog() {

    project_name=$1
    old_version=$2
    new_version=$3
    repository_url=$4
    changelog_filename="$project_name-changelog.txt"
    jira_changelog_filename="$project_name-jira.txt"
    echo " * getting changelog ..."
    cd "$project_name"
    git fetch --all
    git checkout tags/"$old_version" --quiet
    echo "$project_name($repository_url) : $old_version -> $new_version" >> "../changelogs/$changelog_filename"
    echo "$project_name($repository_url) : $old_version -> $new_version" >> "../changelogs/$jira_changelog_filename"
    git log --pretty=format:"  * %s" "$old_version"'..'"$new_version" >> "../changelogs/$changelog_filename"
    git log --pretty=format:"  * %s" "$old_version"'..'"$new_version" --quiet | grep -iEow 'ft-[0-9]+' | sort | uniq >> "../changelogs/$jira_changelog_filename"
    cd ..
    rm -rf "./$project_name"
}

function cloneRepository() {
    project_name=$1
    old_version=$2
    new_version=$3
    repository_url=$4


    if [ "$repository_url" != "null" ];
        then
            echo "[OK] $project_name($repository_url) : $old_version -> $new_version"
            git clone "$repository_url" "$project_name" --quiet
        else
            echo "[Skipped] $project_name has no repository url."
    fi
}
rm -rf ./changelogs
mkdir changelogs

LATEST_TAG=$(git tags | tail -n 1)
git cat-file blob "$LATEST_TAG":"$NEW_LOCK_FILE" > "$OLD_LOCK_FILE"
DEPENDENCIES=$(yq r $OLD_LOCK_FILE dependencies -j | jq ".[].name" | sed "s/\"//g")

for key in $DEPENDENCIES
do
    old_version=$(yq r $OLD_LOCK_FILE dependencies -j | jq ".[] | select(.name==\"$key\").version" | sed "s/\"//g")
    new_version=$(yq r $NEW_LOCK_FILE dependencies -j | jq ".[] | select(.name==\"$key\").version" | sed "s/\"//g")
    repository_url=$(yq r $REQUIREMENTS_FILE dependencies -j | jq ".[] | select(.name==\"$key\").git" | sed "s/\"//g")
    [ "$old_version" != "$new_version" ] && cloneRepository "$key" "$old_version" "$new_version" "$repository_url" && getChangelog "$key" "$old_version" "$new_version" "$repository_url"
done

count=$(find ./changelogs -maxdepth 1 -type f | wc -l | awk '{print $1}')
find ./changelogs -size 0 -delete # delete empty changelogs
if [ "$((count / 2))" == "0" ];
then
    echo "No components changed. There are no changelogs."
else
    echo "$((count / 2)) component(s) changed. "
fi

rm "$OLD_LOCK_FILE"
exit 0