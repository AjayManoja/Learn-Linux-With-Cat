#!/usr/bin/env bash
# Review: find -exec/xargs (S7) + chmod (S3) + find -name (S2)

TASK_INSTRUCTION="Every .sh file under toolkit/ has lost its execute bit. Find them all and make every one executable — without naming a single file yourself."
TASK_CAT_POSE="thinking"
RECALLS="Stage 7 — find -exec, xargs · Stage 2 — find -name · Stage 3 — chmod"

TASK_SUCCESS_MSG="Found and fixed in bulk. Typing filenames one at a time is the thing you have just outgrown."
TASK_SUCCESS_POSE="celebrate"
TASK_FAIL_MSG="All four .sh files under toolkit/ need the execute bit, set by one command."
TASK_FAIL_POSE="confused"

HINT_1="find locates them; chmod fixes them; something has to join the two."
HINT_2="Either -exec chmod +x {} \; or pipe into xargs chmod +x."
HINT_3="Run: find toolkit -name \"*.sh\" -exec chmod +x {} \;"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/toolkit/extra"
    local f
    for f in toolkit/alpha.sh toolkit/beta.sh toolkit/extra/gamma.sh toolkit/extra/delta.sh; do
        echo "#!/usr/bin/env bash" > "${SANDBOX_HOME}/${f}"
        chmod 644 "${SANDBOX_HOME}/${f}" 2>/dev/null || true
    done
}

check_task() {
    check_file_executable "toolkit/alpha.sh" \
        && check_file_executable "toolkit/beta.sh" \
        && check_file_executable "toolkit/extra/gamma.sh" \
        && check_file_executable "toolkit/extra/delta.sh"
}
