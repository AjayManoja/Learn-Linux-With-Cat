#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Process Report"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Final job. Produce process_report.txt containing, in your own
words, the difference between these three things:
  zombie - orphan - stopped
Name all three, and for each one say what state it is in and whether it is
actually a problem.
This is the question you will be asked. Write the answer once, properly."
MISSION_SUCCESS_MSG="Zombie, orphan, stopped. Three states people confuse constantly, and you can now tell them apart on sight."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="All three appeared in this stage. One is dead, one is adopted, one is frozen."
HINT_2="Mention each word, and the state letter that goes with it."
HINT_3="Build it with echo and >>: zombie is Z and dead but unreaped, orphan is re-parented to init, stopped is T and frozen."

setup_mission() {
    rm -f "${SANDBOX_HOME}/process_report.txt"
}

check_mission() {
    check_file_exists "process_report.txt" \
        && check_file_matches "process_report.txt" '[Zz]ombie' \
        && check_file_matches "process_report.txt" '[Oo]rphan' \
        && check_file_matches "process_report.txt" '[Ss]top|frozen|[Ss]uspend'
}
