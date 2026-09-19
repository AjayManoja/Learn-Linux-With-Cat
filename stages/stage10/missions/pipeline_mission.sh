#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Watch and Keep"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I want to see the result AND keep a copy. 👀
List every .log file under logs/, show me the list on screen, and save
the same list to logfiles.txt in one go.
A plain redirect would hide it from me, so that is not the answer."
MISSION_SUCCESS_MSG="Seen and saved in one pass. That is the whole reason tee exists."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="A redirect writes silently. Something else writes and prints."
HINT_2="Pipe your find into tee with the filename."
HINT_3="Run: find logs -name \"*.log\" | tee logfiles.txt"

setup_mission() {
    ensure_sandbox_dir "${SANDBOX_HOME}/logs"
    rm -f "${SANDBOX_HOME}/logfiles.txt"
    echo "x" > "${SANDBOX_HOME}/logs/app.log"
    echo "x" > "${SANDBOX_HOME}/logs/db.log"
    echo "x" > "${SANDBOX_HOME}/logs/notes.txt"
}

check_mission() {
    check_command_matches '\| *tee +' \
        && check_file_exists "logfiles.txt" \
        && check_file_matches "logfiles.txt" 'app\.log' \
        && ! check_file_matches "logfiles.txt" 'notes\.txt'
}
