#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Who Ate the Disk?"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="media/ is enormous and I want to know which file is to blame. 💾
Measure everything in media/, order it by size, and save the ordered
list to sizes.txt — smallest first, human-readable.
The answer should be obvious once it is sorted."
MISSION_SUCCESS_MSG="Measured and ranked. That is the first thing to run on any full disk."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="One command measures, another orders."
HINT_2="du -h on the contents, piped into sort -h, redirected to the file."
HINT_3="Run: du -h media/* | sort -h > sizes.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/sizes.txt"
    ensure_sandbox_dir "${SANDBOX_HOME}/media"
    head -c 2000    /dev/zero | tr '\0' 'a' > "${SANDBOX_HOME}/media/thumbnail.dat"
    head -c 40000   /dev/zero | tr '\0' 'b' > "${SANDBOX_HOME}/media/photo.dat"
    head -c 400000  /dev/zero | tr '\0' 'c' > "${SANDBOX_HOME}/media/video.dat"
}

check_mission() {
    check_file_exists "sizes.txt" \
        && check_file_matches "sizes.txt" 'video\.dat' \
        && check_file_matches "sizes.txt" 'thumbnail\.dat' \
        && [[ "$(tail -1 "${SANDBOX_HOME}/sizes.txt")" == *video.dat* ]]
}
