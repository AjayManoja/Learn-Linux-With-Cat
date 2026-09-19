#!/usr/bin/env bash
# Lesson: for

LESSON_COMMAND="for"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A loop repeats without you repeating yourself:
  for NAME in bird mouse fox; do
      echo \"spotted a \$NAME\"
  done
Each time round, NAME holds the next item. 'done' closes the block.
This is why scripts beat typing: the list can have three items or three
thousand, and the script is the same length either way."

TASK_INSTRUCTION="Write scripts/loop.sh with a 'for' loop that echoes several things, then run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="One block of text, many lines of output. Now you can do a thing to everything."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="scripts/loop.sh needs a for/do/done loop, and you need to run it."
TASK_FAIL_POSE="confused"

HINT_1="The words you need are for, in, do and done."
HINT_2="for X in a b c; do ... done"
HINT_3="Write into scripts/loop.sh: 'for X in a b c; do' / 'echo \$X' / 'done' — then: bash scripts/loop.sh"

check_task() {
    local f="${SANDBOX_HOME}/scripts/loop.sh"
    [[ -f "$f" ]] \
        && grep -q '\bfor\b' "$f" \
        && grep -q '\bdo\b' "$f" \
        && grep -q '\bdone\b' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?loop\.sh ]]
}
