#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Supervisors' Report"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Last job of the stage, and it wants the whole toolkit. 📊
From data/roster.csv, produce supervisors.txt containing only the names
of everyone whose role is 'supervisor'.
The file is comma-separated, the role is the second field, and the name
is the first. There is more than one way to do this — pick yours."
MISSION_SUCCESS_MSG="Filtered on one column, printed another. That is the whole of Stage 6 in a single line."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="You need to select rows by one field and print a different field."
HINT_2="awk does both at once, or grep can select and cut can extract."
HINT_3="Run: awk -F, '\$2 == \"supervisor\" {print \$1}' data/roster.csv > supervisors.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/supervisors.txt"
}

check_mission() {
    check_file_exists "supervisors.txt" \
        && check_file_matches "supervisors.txt" 'Mochi' \
        && check_file_matches "supervisors.txt" 'Juniper' \
        && ! check_file_matches "supervisors.txt" 'Pepper' \
        && ! check_file_matches "supervisors.txt" 'Biscuit'
}
