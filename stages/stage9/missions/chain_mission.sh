#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Only If It Worked"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Build me a safe little sequence on one line. ⛓️
Create a directory called staging, and ONLY if that succeeds, create a
file called staging/ready.txt inside it.
If the directory could not be made, the file must not appear. Use the
operator that means 'and only if that worked'."
MISSION_SUCCESS_MSG="Conditional, on one line, no if block needed. That is what && is for."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Two commands, the second conditional on the first."
HINT_2="mkdir, then &&, then touch."
HINT_3="Run: mkdir staging && touch staging/ready.txt"

setup_mission() {
    rm -rf "${SANDBOX_HOME}/staging"
}

check_mission() {
    check_command_matches '&&' \
        && check_dir_exists "staging" \
        && check_file_exists "staging/ready.txt"
}
