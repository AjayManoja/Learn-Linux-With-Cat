#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The One-Liner"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Everything this stage taught, in one line. 🧰
Write a single line that:
  - counts the .txt files under reports/
  - and puts that count into a sentence in summary.txt
Use command substitution for the count. The file should read something
like: 'Found 4 reports'."
MISSION_SUCCESS_MSG="A command inside a sentence inside a file. You now speak shell, not just commands."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="The count is a command. You need its output as text inside another command."
HINT_2="Wrap the counting pipeline in \$( ) and echo the result into the file."
HINT_3="Run: echo Found \$(ls reports/*.txt | wc -l) reports > summary.txt"

setup_mission() {
    ensure_sandbox_dir "${SANDBOX_HOME}/reports"
    rm -f "${SANDBOX_HOME}/summary.txt"
    local i
    for i in 1 2 3 4; do
        echo "report ${i}" > "${SANDBOX_HOME}/reports/r${i}.txt"
    done
}

check_mission() {
    check_file_exists "summary.txt" \
        && check_file_matches "summary.txt" '4' \
        && check_file_matches "summary.txt" '[A-Za-z]'
}
