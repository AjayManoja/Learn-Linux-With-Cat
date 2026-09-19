#!/usr/bin/env bash
# Lesson: exit status in scripts

LESSON_COMMAND="exit"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Stage 9 showed you that commands return a number. Your scripts
should return one too.
  exit 0   means it worked
  exit 1   means it did not
Without this, every script you write reports success no matter what
happened — and then && and || cannot tell the difference, so nothing
built on top of your script can either."

TASK_INSTRUCTION="Write scripts/ok.sh that prints something and then exits with status 0, and run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Now other commands can react to whether your script worked. That is what makes it a real tool."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="The script needs an explicit exit 0, and you need to run it."
TASK_FAIL_POSE="confused"

HINT_1="Two lines: one that prints, one that exits with a number."
HINT_2="The last line should be: exit 0"
HINT_3="echo '#!/usr/bin/env bash' > scripts/ok.sh / echo 'echo done' >> scripts/ok.sh / echo 'exit 0' >> scripts/ok.sh / bash scripts/ok.sh"

setup_lesson() {
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/ok.sh"
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/ok.sh"
    [[ -f "$f" ]] && grep -qE '^ *exit +0' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?ok\.sh ]]
}
