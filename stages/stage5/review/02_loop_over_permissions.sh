#!/usr/bin/env bash
# Review: for (S5) + chmod (S3)

TASK_INSTRUCTION="Every .sh file in toolbox/ is unreadable to anyone but me. Write scripts/share.sh that loops over them and makes each one 755, then run it."
TASK_CAT_POSE="thinking"
RECALLS="Stage 5 — for · Stage 3 — chmod"

TASK_SUCCESS_MSG="One loop, every file, correct mode. This is the job scripting exists for."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="All three .sh files in toolbox/ need to end up at 755, changed by a loop in your script."
TASK_FAIL_POSE="confused"

HINT_1="You know the loop and you know the mode. Put one inside the other."
HINT_2="for F in toolbox/*.sh; do chmod 755 \$F; done"
HINT_3="Write that loop into scripts/share.sh across three lines, chmod +x it, then: bash scripts/share.sh"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/toolbox"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/share.sh"
    local name
    for name in feed groom play; do
        echo "#!/usr/bin/env bash" > "${SANDBOX_HOME}/toolbox/${name}.sh"
        echo "echo ${name}" >> "${SANDBOX_HOME}/toolbox/${name}.sh"
        chmod 600 "${SANDBOX_HOME}/toolbox/${name}.sh" 2>/dev/null || true
    done
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/share.sh"
    [[ -f "$f" ]] && grep -q '\bfor\b' "$f" \
        && check_file_mode "toolbox/feed.sh"  "755" \
        && check_file_mode "toolbox/groom.sh" "755" \
        && check_file_mode "toolbox/play.sh"  "755"
}
