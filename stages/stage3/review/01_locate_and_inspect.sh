#!/usr/bin/env bash
# Review: find (Stage 2) + ls -l (Stage 3)

TASK_INSTRUCTION="Somewhere below your home there is a file called ledger.dat. Find it without guessing, then show its permissions."
TASK_CAT_POSE="thinking"
RECALLS="Stage 2 — find · Stage 3 — ls -l"

TASK_SUCCESS_MSG="Located it, then read its permissions. Two stages, one problem."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="Find the file first, then run ls -l on the path find gave you."
TASK_FAIL_POSE="confused"

HINT_1="One command searches for files by name. Another shows their permissions."
HINT_2="Start with: find . -name \"ledger.dat\""
HINT_3="Then take the path it prints and run: ls -l <that path>"

setup_challenge() {
    local spots=("archive/old" "archive/new" "records")
    REVIEW_LEDGER_DIR="${spots[$((RANDOM % ${#spots[@]}))]}"
    ensure_sandbox_dir "${SANDBOX_HOME}/${REVIEW_LEDGER_DIR}"
    echo "accounts for the month of March" > "${SANDBOX_HOME}/${REVIEW_LEDGER_DIR}/ledger.dat"
    chmod 640 "${SANDBOX_HOME}/${REVIEW_LEDGER_DIR}/ledger.dat" 2>/dev/null || true

    set_hints \
        "One command searches for files by name. Another shows their permissions." \
        "Start with: find . -name \"ledger.dat\"" \
        "It is at ${REVIEW_LEDGER_DIR}/ledger.dat — now run: ls -l ${REVIEW_LEDGER_DIR}/ledger.dat"
}

check_task() {
    check_command_matches '^ls +-[la]*l[la]* +.*ledger\.dat$'
}
