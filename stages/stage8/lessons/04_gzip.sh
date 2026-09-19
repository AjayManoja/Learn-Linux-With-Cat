#!/usr/bin/env bash
# Lesson: gzip

LESSON_COMMAND="gzip"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'gzip' compresses a single file — and replaces it.
  gzip notes.txt
leaves you with notes.txt.gz and no notes.txt. That surprises people.
'gunzip notes.txt.gz' puts it back. 'zcat' reads a .gz without unpacking.
gzip does one file; tar does many. Together they do both, which is the
next lesson."

TASK_INSTRUCTION="Compress bigfile.txt with gzip."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Smaller — and note the original is gone, replaced by the .gz."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run gzip on bigfile.txt."
TASK_FAIL_POSE="confused"

HINT_1="One command, one filename."
HINT_2="The command is gzip."
HINT_3="Type: gzip bigfile.txt"

setup_lesson() {
    rm -f "${SANDBOX_HOME}/bigfile.txt.gz"
    local i
    : > "${SANDBOX_HOME}/bigfile.txt"
    for (( i = 1; i <= 200; i++ )); do
        echo "line ${i}: the same sort of thing over and over, which compresses well" \
            >> "${SANDBOX_HOME}/bigfile.txt"
    done
}

check_task() {
    check_file_exists "bigfile.txt.gz" && check_file_missing "bigfile.txt"
}
