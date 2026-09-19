#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Pick the Winner"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="You have run all three algorithms on the same four jobs.
Write comparison.txt naming which algorithm gives the lowest average waiting
time, and which gets the short job its answer soonest.
They are not the same algorithm. Mention both by name."
MISSION_SUCCESS_MSG="SJF wins on average, round robin wins on responsiveness. Knowing which you actually want is the whole skill."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Compare the average waiting lines in your three saved files."
HINT_2="One name is sjf, the other is round robin."
HINT_3="Write: sjf has the lowest average waiting at 5.25, round robin finishes the short job soonest"

setup_mission() {
    rm -f "${SANDBOX_HOME}/comparison.txt"
}

check_mission() {
    check_file_exists "comparison.txt" \
        && check_file_matches "comparison.txt" '[Ss][Jj][Ff]|shortest' \
        && check_file_matches "comparison.txt" '[Rr][Rr]|round.?robin'
}
