#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Empty Directories"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Someone made a lot of directories and filled almost none of them. 🗂️
Find every directory below your home and save the list to dirs.txt.
Directories only — I do not want a single file in that list."
MISSION_SUCCESS_MSG="Every directory, no files, in one command. Searching by type beats searching by name."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="find can filter by what a thing is."
HINT_2="-type d selects directories; a redirect saves the result."
HINT_3="Run: find . -type d > dirs.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/dirs.txt"
    local d
    for d in attic attic/left attic/right cellar cellar/cold shed; do
        ensure_sandbox_dir "${SANDBOX_HOME}/${d}"
    done
    echo "one lonely file" > "${SANDBOX_HOME}/shed/rake.txt"
}

check_mission() {
    check_file_exists "dirs.txt" \
        && check_file_matches "dirs.txt" 'attic' \
        && check_file_matches "dirs.txt" 'cellar' \
        && ! check_file_matches "dirs.txt" 'rake\.txt'
}
