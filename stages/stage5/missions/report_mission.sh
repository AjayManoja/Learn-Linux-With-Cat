#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Automatic Report"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Do the Stage 4 tally again — but this time don't type it.
Write scripts/report.sh that, when run, counts the entries in data.txt
and writes the result into nap_report.txt.
It must contain a loop or an if, be executable, and produce the file
when you run it. The script does the work; you just start it."
MISSION_SUCCESS_MSG="You automated a job you used to do by hand. That's the entire point of scripting."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="The commands are the ones from Stage 4. The new part is putting them in a file."
HINT_2="Inside the script: sort data.txt | uniq -c > nap_report.txt"
HINT_3="Write a shebang, then 'for X in 1; do' / 'sort data.txt | uniq -c > nap_report.txt' / 'done', chmod +x it, and run it."

setup_mission() {
    mkdir -p "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/report.sh" "${SANDBOX_HOME}/nap_report.txt"
}

check_mission() {
    local f="${SANDBOX_HOME}/scripts/report.sh"
    # The report file must exist AND the script must be what made it, which is
    # why both the script's contents and its output are checked.
    [[ -f "$f" ]] \
        && [[ -x "$f" ]] \
        && { grep -qE '\b(for|if)\b' "$f"; } \
        && check_file_exists "nap_report.txt" \
        && check_file_matches "nap_report.txt" '[0-9]+ +windowsill'
}
