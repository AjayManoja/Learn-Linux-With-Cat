#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Two Workers, One Counter"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Two workers update the same counter and the result is wrong.
Find out why, and write it down.
  1. Run the race demo and note the number you get
  2. Run it again and note the different number
  3. Write your explanation to why_wrong.txt
Your explanation must name what is happening and say which two operations
the scheduler is interrupting between."
MISSION_SUCCESS_MSG="A race condition on a read-modify-write. You diagnosed it from the symptom, which is how you will meet it in real life."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="The answer is the name of the bug plus the two operations it happens between."
HINT_2="Mention 'race condition', and the read and the write."
HINT_3="Write something like: race condition - the scheduler switches between the read and the write, so both threads write the same value"

setup_mission() {
    rm -f "${SANDBOX_HOME}/why_wrong.txt"
}

check_mission() {
    check_file_exists "why_wrong.txt" \
        && check_file_matches "why_wrong.txt" '[Rr]ace' \
        && check_file_matches "why_wrong.txt" '[Rr]ead' \
        && check_file_matches "why_wrong.txt" '[Ww]rite'
}
