#!/usr/bin/env bash
# Review: ln -s (S7) + script (S5) + $1 (S5)

TASK_INSTRUCTION="Write scripts/link.sh that takes a filename as \$1 and creates a symbolic link to it called latest. Run it on reports/march.txt."
TASK_CAT_POSE="thinking"
RECALLS="Stage 7 — ln -s · Stage 5 — scripts, \$1"

TASK_SUCCESS_MSG="A reusable tool for a thing you learned ten minutes ago. That is the payoff for Stage 5."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="latest must be a symbolic link, made by a script that used \$1."
TASK_FAIL_POSE="confused"

HINT_1="The script body is one ln -s command using the argument."
HINT_2="Inside: ln -s \$1 latest"
HINT_3="echo 'ln -s \$1 latest' >> scripts/link.sh, chmod +x it, then: bash scripts/link.sh reports/march.txt"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/reports"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/link.sh" "${SANDBOX_HOME}/latest"
    echo "March was uneventful." > "${SANDBOX_HOME}/reports/march.txt"
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/link.sh"
    [[ -f "$f" ]] && grep -q '\$1' "$f" && [[ -L "${SANDBOX_HOME}/latest" ]]
}
