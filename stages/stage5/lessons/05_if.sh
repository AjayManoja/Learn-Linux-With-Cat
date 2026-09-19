#!/usr/bin/env bash
# Lesson: if

LESSON_COMMAND="if"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A script that decides. The shape is always the same:
  if [ -f data.txt ]; then
      echo \"found it\"
  else
      echo \"missing\"
  fi
The spaces inside the brackets are required — [ is a command, not punctuation.
'-f' asks 'does this file exist?'. 'fi' closes the block: 'if' backwards."

TASK_INSTRUCTION="Write scripts/check.sh that uses 'if' to test whether data.txt exists, then run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Your script made a decision on its own. That's the line between a list and a program."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="scripts/check.sh needs an if/then/fi block, and you need to run it."
TASK_FAIL_POSE="confused"

HINT_1="Build it with echo and >> a line at a time, then run it."
HINT_2="You need the words if, then and fi in the file."
HINT_3="Write these lines into scripts/check.sh: 'if [ -f data.txt ]; then' / 'echo found' / 'fi' — then: bash scripts/check.sh"

check_task() {
    local f="${SANDBOX_HOME}/scripts/check.sh"
    [[ -f "$f" ]] \
        && grep -q '\bif\b' "$f" \
        && grep -q '\bthen\b' "$f" \
        && grep -q '\bfi\b' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?check\.sh ]]
}
