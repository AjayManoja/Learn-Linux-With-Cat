#!/usr/bin/env bash
# Review: ls -la (S1) + chmod (S3) + cat (S1) + grep (S2)

TASK_INSTRUCTION="There is a hidden, locked file somewhere under archive/. Reveal it, unlock it, and find the line in it that mentions 'key'."
TASK_CAT_POSE="thinking"
RECALLS="Stage 1 — ls -la · Stage 3 — chmod · Stage 2 — grep"

TASK_SUCCESS_MSG="Hidden, then locked, then buried in a file — and you got through all three."
TASK_SUCCESS_POSE="celebrate"
TASK_FAIL_MSG="Three obstacles: it is hidden, it is at 000, and the line you want is one of many."
TASK_FAIL_POSE="confused"

HINT_1="Hidden files need ls -la. Locked files need chmod. Buried lines need grep."
HINT_2="Look in archive/ with ls -la, then chmod the file you find, then grep it."
HINT_3="Run: chmod 600 archive/.manifest   then: grep key archive/.manifest"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/archive"
    local manifest="${SANDBOX_HOME}/archive/.manifest"
    rm -f "$manifest" 2>/dev/null || true
    {
        echo "crate 1: winter blankets"
        echo "crate 2: assorted string"
        echo "crate 3: the spare key to the shed"
        echo "crate 4: empty boxes, kept for sitting in"
    } > "$manifest"
    chmod 000 "$manifest" 2>/dev/null || true
}

check_task() {
    [[ -r "${SANDBOX_HOME}/archive/.manifest" ]] \
        && check_command_matches '^grep +.*key.* +.*\.manifest$'
}
