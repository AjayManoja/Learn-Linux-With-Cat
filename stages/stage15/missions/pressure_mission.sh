#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Reserved Is Not Used"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Prove the difference between reserving memory and using it.
Run the memory demo and save its output to pages.txt.
Then confirm the file shows both halves: address space growing while RSS
stays flat, and then RSS catching up once every page is touched."
MISSION_SUCCESS_MSG="256 MB of address space cost almost nothing until it was touched. That is why VSZ is a useless measure of memory usage and RSS is the one to watch."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Run the demo and redirect its output into the file."
HINT_2="python3 demos/memory_demo.py > pages.txt"
HINT_3="Run exactly: python3 demos/memory_demo.py > pages.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/pages.txt"
}

check_mission() {
    check_file_exists "pages.txt" \
        && check_file_matches "pages.txt" 'untouched' \
        && check_file_matches "pages.txt" 'after touching every page'
}
