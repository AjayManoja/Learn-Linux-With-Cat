#!/usr/bin/env bash
# Review: du/sort (S7) + chmod (S3) + ls -l (S3)

TASK_INSTRUCTION="Find the largest file in hoard/, then lock it to 600 so nobody else can read it."
TASK_CAT_POSE="thinking"
RECALLS="Stage 7 — du, sort · Stage 3 — chmod"

TASK_SUCCESS_MSG="Measured to find it, then locked it. Stage 7 asked the question, Stage 3 answered it."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="The biggest file in hoard/ is the one that needs to be 600."
TASK_FAIL_POSE="confused"

HINT_1="First work out which file is biggest, then change its permissions."
HINT_2="du -h hoard/* | sort -h will show you which. Then chmod it."
HINT_3="The largest is hoard/treasure.dat. Run: chmod 600 hoard/treasure.dat"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/hoard"
    head -c 1000   /dev/zero | tr '\0' 'x' > "${SANDBOX_HOME}/hoard/pebble.dat"
    head -c 9000   /dev/zero | tr '\0' 'y' > "${SANDBOX_HOME}/hoard/stone.dat"
    head -c 90000  /dev/zero | tr '\0' 'z' > "${SANDBOX_HOME}/hoard/treasure.dat"
    chmod 644 "${SANDBOX_HOME}/hoard/"*.dat 2>/dev/null || true
}

check_task() {
    check_file_mode "hoard/treasure.dat" "600" \
        && check_file_mode "hoard/pebble.dat" "644"
}
