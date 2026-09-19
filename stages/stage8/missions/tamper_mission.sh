#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Someone Edited the Charter"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I have two copies of the charter and I think one has been
tampered with. 🔍
documents/charter.txt is mine. vault/charter_copy.txt came back from
the dog. Find out whether they differ, and if they do, save the
differences to tampering.txt."
MISSION_SUCCESS_MSG="Caught. The dog's copy had an extra clause and now there is a record of it."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="One command reports the differences between two files."
HINT_2="diff takes both files; a redirect saves what it prints."
HINT_3="Run: diff documents/charter.txt vault/charter_copy.txt > tampering.txt"

setup_mission() {
    ensure_sandbox_dir "${SANDBOX_HOME}/vault"
    rm -f "${SANDBOX_HOME}/tampering.txt"
    {
        cat "${SANDBOX_HOME}/documents/charter.txt" 2>/dev/null
        echo "6. The dog may use the sofa whenever it likes."
    } > "${SANDBOX_HOME}/vault/charter_copy.txt"
}

check_mission() {
    check_file_exists "tampering.txt" \
        && check_file_matches "tampering.txt" 'dog may use the sofa'
}
