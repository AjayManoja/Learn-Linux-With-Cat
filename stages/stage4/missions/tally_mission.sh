#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Sightings Tally"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I kept a list of everything I spotted in the garden. 🐦
data/sightings.txt has the raw list, one per line, in no order.
Count how many times each animal appears, and save the tally
into a file called tally.txt so I can read it later."
MISSION_SUCCESS_MSG="A counted, sorted tally in a file — built from three commands and no program."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="You know how to count repeats. Now you also know how to send output to a file."
HINT_2="sort the file, pipe into uniq -c, and redirect the result."
HINT_3="Type: sort data/sightings.txt | uniq -c > tally.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/tally.txt"
}

check_mission() {
    # The tally must name several animals with counts, which only a real
    # sort|uniq -c can produce.
    check_file_exists "tally.txt" \
        && check_file_matches "tally.txt" '[0-9]+ +bird' \
        && check_file_matches "tally.txt" '[0-9]+ +mouse' \
        && check_file_matches "tally.txt" '[0-9]+ +squirrel'
}
