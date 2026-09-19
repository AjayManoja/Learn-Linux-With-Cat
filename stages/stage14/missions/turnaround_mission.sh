#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Do the Arithmetic"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Interviewers ask you to compute these by hand, so do it once.
For the FCFS run, write answers.txt containing both:
  - the average waiting time
  - the average turnaround time
Both are already in fcfs.txt. Knowing which is which is the point.
  turnaround = finish - arrival
  waiting    = turnaround - burst"
MISSION_SUCCESS_MSG="Waiting 6.00, turnaround 10.00. Turnaround includes the time actually spent running; waiting does not."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Both figures are printed at the bottom of the fcfs output."
HINT_2="grep them out of fcfs.txt and redirect into answers.txt."
HINT_3="Run: grep average fcfs.txt > answers.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/answers.txt"
}

check_mission() {
    check_file_exists "answers.txt" \
        && check_file_matches "answers.txt" '6\.00|6' \
        && check_file_matches "answers.txt" '10\.00|10'
}
