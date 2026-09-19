#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Concurrency Summary"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="One file, four ideas, your own words.
Write concurrency.txt covering all four:
  race condition - mutex - deadlock - starvation
For each, one line is enough: what it is, and whether a lock causes it or
cures it.
Two of these are caused by the fix for the first one. That is the point of
the stage."
MISSION_SUCCESS_MSG="Races, locks, deadlock, starvation. You have seen every one of them happen on this machine rather than in a diagram."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="All four words appeared in this stage's lessons."
HINT_2="One line each, naming the word."
HINT_3="Append four lines with >>, one per term."

setup_mission() {
    rm -f "${SANDBOX_HOME}/concurrency.txt"
}

check_mission() {
    check_file_exists "concurrency.txt" \
        && check_file_matches "concurrency.txt" '[Rr]ace' \
        && check_file_matches "concurrency.txt" '[Mm]utex|[Ll]ock' \
        && check_file_matches "concurrency.txt" '[Dd]eadlock' \
        && check_file_matches "concurrency.txt" '[Ss]tarvation'
}
