#!/usr/bin/env bash
# Lesson: putting it together

LESSON_COMMAND="if + for"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Loops and decisions nest inside each other, and that combination
is most of the scripts ever written:
  for F in *.txt; do
      if [ -f \"\$F\" ]; then
          echo \"\$F exists\"
      fi
  done
Note the quotes around \"\$F\" — filenames can contain spaces, and quoting
stops the shell splitting them. Get into the habit now."

TASK_INSTRUCTION="Write scripts/audit.sh containing both a 'for' loop and an 'if' inside it, then run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A loop that makes a decision every time round. That's a real script."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="scripts/audit.sh needs both a for loop and an if, and you need to run it."
TASK_FAIL_POSE="confused"

HINT_1="Both structures in the same file, one inside the other."
HINT_2="Open the for loop, put the if inside, close the if with fi, close the loop with done."
HINT_3="Lines: 'for F in *.txt; do' / 'if [ -f \"\$F\" ]; then' / 'echo \$F' / 'fi' / 'done' — then: bash scripts/audit.sh"

check_task() {
    local f="${SANDBOX_HOME}/scripts/audit.sh"
    [[ -f "$f" ]] \
        && grep -q '\bfor\b' "$f" && grep -q '\bdone\b' "$f" \
        && grep -q '\bif\b' "$f"  && grep -q '\bfi\b' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?audit\.sh ]]
}
