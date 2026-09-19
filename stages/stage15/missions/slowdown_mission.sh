#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Why Is It Slow?"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="A process has become very slow and someone says the machine
is out of memory. Investigate properly and write your finding to verdict.txt.
Your verdict must address the thing everyone gets wrong: whether a low
'free' figure actually means there is a memory problem.
Name the number that answers the question instead, and name the kind of
page fault that makes a machine feel slow."
MISSION_SUCCESS_MSG="Available, not free. Major faults, not minor ones. You can now argue with a monitoring dashboard and win."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Two things: which memory number actually matters, and which fault type is expensive."
HINT_2="Mention 'available' and 'major' faults."
HINT_3="Write: low free is normal because cache is reclaimable - check MemAvailable, and look for major page faults which mean disk reads"

setup_mission() {
    rm -f "${SANDBOX_HOME}/verdict.txt"
}

check_mission() {
    check_file_exists "verdict.txt" \
        && check_file_matches "verdict.txt" '[Aa]vailable' \
        && check_file_matches "verdict.txt" '[Mm]ajor' \
        && check_file_matches "verdict.txt" '[Cc]ache|[Rr]eclaim'
}
