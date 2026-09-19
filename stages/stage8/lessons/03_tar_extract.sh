#!/usr/bin/env bash
# Lesson: tar -xf

LESSON_COMMAND="tar -xf"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'-x' extracts. The three you need are -c, -t and -x:
create, list, extract. Same -f each time.
  tar -xf papers.tar
unpacks into the current directory. There is no 'are you sure' — it will
overwrite whatever is in its way, which is why you listed it first."

TASK_INSTRUCTION="Extract papers.tar inside the restore directory. Move there first."
TASK_CAT_POSE="thinking"
LESSON_START_DIR="restore"

TASK_SUCCESS_MSG="Unpacked, and safely away from the originals. Extracting into an empty directory is a good habit."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="cd into restore, then extract ../papers.tar there."
TASK_FAIL_POSE="confused"

HINT_1="Extract from inside the directory you want the files to land in."
HINT_2="The archive is one level up, so refer to it as ../papers.tar"
HINT_3="Type: tar -xf ../papers.tar"

setup_lesson() {
    ensure_sandbox_dir "${SANDBOX_HOME}/restore"
}

check_task() {
    check_dir_exists "restore/documents" || check_file_exists "restore/documents/charter.txt"
}
