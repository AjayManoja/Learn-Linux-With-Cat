#!/usr/bin/env bash
# Review: chmod (Stage 3) + cat (Stage 1) + grep (Stage 2)

TASK_INSTRUCTION="notes/sealed.txt is locked and I need one line from it: the one mentioning 'fish'. Open it, then search it — don't read the whole thing."
TASK_CAT_POSE="thinking"
RECALLS="Stage 3 — chmod · Stage 2 — grep"

TASK_SUCCESS_MSG="Unlocked it, then searched instead of reading. That is the habit worth keeping."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="It needs two steps: make it readable, then grep it for fish."
TASK_FAIL_POSE="confused"

HINT_1="You cannot search a file you are not allowed to read."
HINT_2="First chmod it so you can read it, then use grep rather than cat."
HINT_3="Run: chmod 600 notes/sealed.txt   then: grep fish notes/sealed.txt"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/notes"
    local sealed="${SANDBOX_HOME}/notes/sealed.txt"
    rm -f "$sealed" 2>/dev/null || true
    {
        echo "The bowl is blue."
        echo "The bird is quick."
        echo "The best fish is behind the third shelf."
        echo "The dog is asleep."
    } > "$sealed"
    chmod 000 "$sealed" 2>/dev/null || true
}

check_task() {
    # Both halves: the file had to be unlocked, and searched rather than dumped.
    [[ -r "${SANDBOX_HOME}/notes/sealed.txt" ]] \
        && check_command_matches '^grep +.*fish.* +.*sealed\.txt$'
}
