#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Just the Names"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="data/roster.csv has four columns and I only want one. 📋
Pull out just the name column — the first field, comma-separated —
and save it to names.txt.
The header line can stay; I am not fussy."
MISSION_SUCCESS_MSG="One column out of four, extracted and saved. No editor involved."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="The fields are separated by commas and you want the first."
HINT_2="cut -d, -f1 pulls it out; a redirect puts it in a file."
HINT_3="Run: cut -d, -f1 data/roster.csv > names.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/names.txt"
}

check_mission() {
    check_file_exists "names.txt" \
        && check_file_matches "names.txt" '^Mochi$' \
        && check_file_matches "names.txt" '^Biscuit$' \
        && ! check_file_matches "names.txt" 'windowsill'
}
