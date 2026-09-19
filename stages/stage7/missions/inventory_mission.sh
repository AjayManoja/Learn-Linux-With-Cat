#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Full Inventory"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="One report, everything you know. 📦
Produce inventory.txt containing a line count for every .md file below
your home — one line per file, showing the count and the filename.
Find them by name, then run the count on each. There are two ways to do
the second half and both are correct."
MISSION_SUCCESS_MSG="Found by pattern, counted in bulk. -exec or xargs — either one makes you dangerous."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="First find the files, then get wc to run on all of them."
HINT_2="Either -exec wc -l {} \; or pipe into xargs wc -l."
HINT_3="Run: find . -name \"*.md\" | xargs wc -l > inventory.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/inventory.txt"
    ensure_sandbox_dir "${SANDBOX_HOME}/projects/deep"
    printf 'a\nb\nc\n'       > "${SANDBOX_HOME}/projects/deep/buried.md"
    printf 'one\ntwo\n'      > "${SANDBOX_HOME}/projects/plan.md"
}

check_mission() {
    check_file_exists "inventory.txt" \
        && check_file_matches "inventory.txt" '[0-9]+ .*notes\.md' \
        && check_file_matches "inventory.txt" '[0-9]+ .*buried\.md'
}
