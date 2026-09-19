#!/usr/bin/env bash
# Review: find -type (S7) + sed (S6) + redirect (S4)

TASK_INSTRUCTION="Find every .cfg file below config/, and produce fixed.txt containing their contents with 'enabled=no' changed to 'enabled=yes'."
TASK_CAT_POSE="thinking"
RECALLS="Stage 7 — find · Stage 6 — sed · Stage 4 — >"

TASK_SUCCESS_MSG="Located by pattern, rewritten by sed, captured by a redirect. Three stages, one pipeline."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="fixed.txt must contain enabled=yes and no enabled=no."
TASK_FAIL_POSE="confused"

HINT_1="Get the contents of the files first, then substitute, then save."
HINT_2="cat config/*.cfg | sed 's/enabled=no/enabled=yes/g' > fixed.txt"
HINT_3="Run exactly: cat config/*.cfg | sed 's/enabled=no/enabled=yes/g' > fixed.txt"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/config"
    rm -f "${SANDBOX_HOME}/fixed.txt"
    printf 'name=heater\nenabled=no\n' > "${SANDBOX_HOME}/config/heater.cfg"
    printf 'name=fountain\nenabled=no\n' > "${SANDBOX_HOME}/config/fountain.cfg"
}

check_task() {
    check_file_exists "fixed.txt" \
        && check_file_matches "fixed.txt" 'enabled=yes' \
        && ! check_file_matches "fixed.txt" 'enabled=no'
}
