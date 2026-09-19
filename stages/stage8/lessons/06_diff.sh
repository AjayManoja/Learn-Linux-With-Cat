#!/usr/bin/env bash
# Lesson: diff

LESSON_COMMAND="diff"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'diff' shows what changed between two files.
  diff old.txt new.txt
Lines starting '<' are in the first file, '>' are in the second.
If the files are identical it prints nothing at all — silence means
'no difference', which is the Unix habit of saying nothing when there is
nothing to say."

TASK_INSTRUCTION="Compare documents/charter.txt with documents/charter_v2.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Only the lines that changed, and which side they came from."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run diff on the two charter files."
TASK_FAIL_POSE="confused"

HINT_1="One command, two filenames."
HINT_2="The command is diff."
HINT_3="Type: diff documents/charter.txt documents/charter_v2.txt"

setup_lesson() {
    local v2="${SANDBOX_HOME}/documents/charter_v2.txt"
    ensure_sandbox_dir "${SANDBOX_HOME}/documents"
    sed 's/Dinner is at six./Dinner is at five./' \
        "${SANDBOX_HOME}/documents/charter.txt" > "$v2" 2>/dev/null || true
}

check_task() {
    check_command_matches '^diff +.*charter.*charter'
}
