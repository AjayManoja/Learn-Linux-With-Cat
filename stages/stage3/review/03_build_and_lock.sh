#!/usr/bin/env bash
# Review: mkdir + touch (Stage 1) + chmod (Stage 3)

TASK_INSTRUCTION="Build me a private drop box: a directory called dropbox, a file inside it called secret.txt, and that file set to 600 so only I can read it."
TASK_CAT_POSE="thinking"
RECALLS="Stage 1 — mkdir, touch · Stage 3 — chmod"

TASK_SUCCESS_MSG="Created, filled and locked. That is a week of Stage 1 and Stage 3 in three commands."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="I need dropbox/ to exist, secret.txt inside it, and that file at exactly 600."
TASK_FAIL_POSE="confused"

HINT_1="Three commands, one per part: make the directory, make the file, set the mode."
HINT_2="mkdir makes the directory, touch makes the file, chmod sets who may read it."
HINT_3="Run: mkdir dropbox / touch dropbox/secret.txt / chmod 600 dropbox/secret.txt"

setup_challenge() {
    rm -rf "${SANDBOX_HOME}/dropbox" 2>/dev/null || true
}

check_task() {
    check_dir_exists "dropbox" \
        && check_file_exists "dropbox/secret.txt" \
        && check_file_mode "dropbox/secret.txt" "600"
}
