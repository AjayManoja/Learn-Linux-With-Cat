#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Nap Census"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Last job of the stage, and it uses everything. 📊
data/naps.txt lists every nap spot I used, with repeats.
I want a report at report.txt containing, in this order:
  1. a header line that says exactly: NAP CENSUS
  2. underneath it, the count of each spot
Build the header first, then append the tally — remember which
redirect replaces and which one adds."
MISSION_SUCCESS_MSG="Header, then tally, in one file. You just wrote a report with two commands."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Two writes to the same file: the first creates it, the second must not destroy it."
HINT_2="Use > for the header, then >> for the tally."
HINT_3="Run: echo NAP CENSUS > report.txt    then: sort data/naps.txt | uniq -c >> report.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/report.txt"
}

check_mission() {
    # The header has to survive, which only happens if the tally was appended.
    check_file_exists "report.txt" \
        && check_file_matches "report.txt" '^NAP CENSUS' \
        && check_file_matches "report.txt" '[0-9]+ +windowsill' \
        && check_file_matches "report.txt" '[0-9]+ +box'
}
