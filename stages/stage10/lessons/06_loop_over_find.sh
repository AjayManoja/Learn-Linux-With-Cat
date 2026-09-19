#!/usr/bin/env bash
# Lesson: looping over find results

LESSON_COMMAND="for F in \$(find ...)"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Stage 7 gave you -exec and xargs. A loop is the third way, and
the one you reach for when the work is more than a single command:
  for F in \$(find logs -name \"*.log\"); do
      echo \"checking \$F\"
  done
The substitution runs find, the loop walks its results.
One caveat worth knowing now: this breaks on filenames containing spaces.
For those, xargs -0 or -exec is safer. Most of the time you are fine."

TASK_INSTRUCTION="Write scripts/walk.sh that loops over the .log files under logs/ and echoes each one, then run it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="find inside a loop inside a script. Three stages stacked on top of each other."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="The script needs a for loop over a find, and you need to run it."
TASK_FAIL_POSE="confused"

HINT_1="The loop walks whatever the substitution produces."
HINT_2="for F in \$(find logs -name \"*.log\"); do echo \$F; done"
HINT_3="Write those three lines into scripts/walk.sh, then: bash scripts/walk.sh"

setup_lesson() {
    ensure_sandbox_dir "${SANDBOX_HOME}/logs"
    ensure_sandbox_dir "${SANDBOX_HOME}/scripts"
    rm -f "${SANDBOX_HOME}/scripts/walk.sh"
    echo "started" > "${SANDBOX_HOME}/logs/app.log"
    echo "started" > "${SANDBOX_HOME}/logs/db.log"
}

check_task() {
    local f="${SANDBOX_HOME}/scripts/walk.sh"
    [[ -f "$f" ]] \
        && grep -q '\bfor\b' "$f" && grep -q 'find' "$f" \
        && [[ "${LAST_COMMAND:-}" =~ (\./|bash +|sh +)(scripts/)?walk\.sh ]]
}
