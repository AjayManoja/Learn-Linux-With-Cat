#!/usr/bin/env bash
# Lesson: checking arguments

LESSON_COMMAND="if [ -z \$1 ]"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A script that needs an argument should say so when it does not
get one, instead of failing strangely three lines later.
  if [ -z \"\$1\" ]; then
      echo \"usage: myscript <file>\"
      exit 1
  fi
'-z' means 'is empty'. Note the exit 1 — the script reports failure, so
whatever called it knows.
This four-line block is the difference between a script and a tool."

TASK_INSTRUCTION="Write scripts/need.sh that exits with an error message if given no argument, then run it with no argument."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="It refused politely and reported failure. Every script you write from now on should start like this."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="The script needs a -z test on \$1 and an exit 1, and you need to run it with nothing after it."
TASK_FAIL_POSE="confused"

HINT_1="Test whether the first argument is empty, and stop if it is."
HINT_2="if [ -z \"\$1\" ]; then ... exit 1 ... fi"
HINT_3="Build it with echo and >>, then run: bash scripts/need.sh"

setup_lesson() {
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/need.sh"
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/need.sh"
    [[ -f "$f" ]] \
        && grep -q '\-z' "$f" \
        && grep -qE 'exit +1' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?need\.sh[[:space:]]*$ ]]
}
