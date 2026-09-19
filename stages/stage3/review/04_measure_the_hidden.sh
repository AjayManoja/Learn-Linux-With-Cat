#!/usr/bin/env bash
# Review: ls -la (Stage 1) + wc (Stage 2) + cd (Stage 1)

TASK_INSTRUCTION="There is a hidden file inside the vault_notes directory. Go in, find it, and tell me how many lines it has."
TASK_CAT_POSE="thinking"
RECALLS="Stage 1 — cd, ls -la · Stage 2 — wc"

TASK_SUCCESS_MSG="Navigated, revealed, measured. Nothing there was from this stage alone."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="Move into vault_notes, reveal the hidden file, then count its lines with wc -l."
TASK_FAIL_POSE="confused"

HINT_1="A plain ls will not show it. Something starting with a dot never is."
HINT_2="cd into vault_notes and run ls -la to see what is really there."
HINT_3="The file is .tally. Run: wc -l .tally"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/vault_notes"
    local tally="${SANDBOX_HOME}/vault_notes/.tally"
    rm -f "$tally" 2>/dev/null || true
    local i
    for (( i = 1; i <= 12; i++ )); do
        echo "entry ${i}: one more nap accounted for" >> "$tally"
    done
}

check_task() {
    check_command_matches '^wc +-l +.*\.tally$'
}
