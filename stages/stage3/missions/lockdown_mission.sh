#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Lock It Down"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Set the locks properly on my work folder. 🔐
1. secrets.txt  -> 600  (only I can read or write it)
2. report.txt   -> 644  (everyone may read, only I may change it)
3. backup.sh    -> 755  (everyone may read and run it, only I may change it)
Get all three right and the folder is secure."
MISSION_SUCCESS_MSG="600, 644, 755 — the three modes you'll use for the rest of your life."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Read is 4, write is 2, execute is 1. Add them per audience."
HINT_2="600 is rw-------, 644 is rw-r--r--, 755 is rwxr-xr-x."
HINT_3="Run: chmod 600 secrets.txt / chmod 644 report.txt / chmod 755 backup.sh"

setup_mission() {
    # Start them all wrong, so the mission cannot pass without doing the work.
    chmod 666 "${SANDBOX_HOME}/work/secrets.txt" 2>/dev/null || true
    chmod 600 "${SANDBOX_HOME}/work/report.txt"  2>/dev/null || true
    chmod 644 "${SANDBOX_HOME}/work/backup.sh"   2>/dev/null || true
}

check_mission() {
    check_file_mode "work/secrets.txt" "600" \
        && check_file_mode "work/report.txt" "644" \
        && check_file_mode "work/backup.sh" "755"
}
