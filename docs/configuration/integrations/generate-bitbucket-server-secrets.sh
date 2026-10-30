#!/usr/bin/env bash

# This script moved to scripts/generate-bitbucket-server-secrets.sh. This stub keeps the old
# raw.githubusercontent.com link working for saved commands. Remove it once
# the old link is no longer in use (OD-1046).

NEW_URL="https://raw.githubusercontent.com/codacy/chart/master/scripts/generate-bitbucket-server-secrets.sh"

echo "Note: this script moved to $NEW_URL. Update any saved commands to use that URL." >&2

script=$(curl -fsSL "$NEW_URL") || { echo "Couldn't download $NEW_URL" >&2; exit 1; }
exec bash -c "$script" "generate-bitbucket-server-secrets.sh" "$@"
