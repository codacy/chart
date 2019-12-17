#!/bin/bash
set -e
REQUIREMENTS_FILE="codacy/requirements.yaml"
OLD_LOCK_FILE="codacy/requirements_old.lock"
NEW_LOCK_FILE="codacy/requirements.lock"
DEPENDENCIES=$(yq r $OLD_LOCK_FILE dependencies -j | jq ".[].name" | sed "s/\"//g")

function getChangelog() {
    CHANGELOG_FILENAME=$3
    JIRA_CHANGELOG_FILENAME=$4
    git fetch --all
    git checkout tags/"$1" --quiet
    git log --pretty=format:"  * %s" "$1"'..'"$2" > "../changelogs/$CHANGELOG_FILENAME"
    git log --pretty=format:"  * %s" "$1"'..'"$2" --quiet | grep -iEow 'ft-[0-9]+' | sort | uniq > "../changelogs/$JIRA_CHANGELOG_FILENAME"
}

function cloneRepository() {
    PROJECT_NAME=$1
    REPOSITORY_URL=$(yq r $REQUIREMENTS_FILE dependencies -j | jq ".[] | select(.name==\"$PROJECT_NAME\").git" | sed "s/\"//g")
    OLD_VERSION=$2
    NEW_VERSION=$3
    CHANGELOG_FILENAME="$PROJECT_NAME-changelog.txt"
    JIRA_CHANGELOG_FILENAME="$PROJECT_NAME-jira.txt"

    if [ "$REPOSITORY_URL" != "null" ];
        then
            echo "[OK] $PROJECT_NAME($REPOSITORY_URL) -> $OLD_VERSION : $NEW_VERSION"
            git clone "$REPOSITORY_URL" "$PROJECT_NAME" --quiet
            cd "$PROJECT_NAME"
            getChangelog "$OLD_VERSION" "$NEW_VERSION" "$CHANGELOG_FILENAME" "$JIRA_CHANGELOG_FILENAME";
            cd ..
            rm -rf "./$PROJECT_NAME"
        else
            echo "[Skipped] $PROJECT_NAME has no repository url."
    fi
}
rm -rf ./changelogs
mkdir changelogs
for key in $DEPENDENCIES
do
    OLD_VERSION=$(yq r $OLD_LOCK_FILE dependencies -j | jq ".[] | select(.name==\"$key\").version" | sed "s/\"//g")
    NEW_VERSION=$(yq r $NEW_LOCK_FILE dependencies -j | jq ".[] | select(.name==\"$key\").version" | sed "s/\"//g")
    [ "$OLD_VERSION" != "$NEW_VERSION" ] && cloneRepository "$key" "$OLD_VERSION" "$NEW_VERSION"
done

count=$(find ./changelogs -maxdepth 1 -type f | wc -l | awk '{print $1}')
find ./changelogs -size 0 -delete # delete empty changelogs
if [ "$((count / 2))" == "0" ];
then
    echo "No components changed. There are no changelogs."
else
    echo "$((count / 2)) component(s) changed. "
fi

exit 0