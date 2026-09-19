#!/usr/bin/env bash
# Review: find (S2) + wc (S2) + if (S5) + >> (S4)

TASK_INSTRUCTION="Write scripts/audit.sh that counts the .txt files under reports/ and, if there are any, appends a line to audit.log saying so. Run it."
TASK_CAT_POSE="thinking"
RECALLS="Stage 2 — find, wc · Stage 5 — if · Stage 4 — >>"

TASK_SUCCESS_MSG="Counted, decided, recorded. Four stages in one file."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="The script needs an if, and running it must leave a non-empty audit.log."
TASK_FAIL_POSE="confused"

HINT_1="Count first, then decide based on the count, then write the result."
HINT_2="if [ -d reports ]; then ... fi — and inside, append with >>"
HINT_3="Lines: 'if [ -d reports ]; then' / 'find reports -name \"*.txt\" | wc -l >> audit.log' / 'fi'"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/reports"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/audit.sh" "${SANDBOX_HOME}/audit.log"
    local i
    for i in 1 2 3 4; do
        echo "report ${i}" > "${SANDBOX_HOME}/reports/r${i}.txt"
    done
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/audit.sh"
    [[ -f "$f" ]] \
        && grep -q '\bif\b' "$f" && grep -q '\bfi\b' "$f" \
        && check_file_exists "audit.log" \
        && [[ -s "${SANDBOX_HOME}/audit.log" ]]
}
