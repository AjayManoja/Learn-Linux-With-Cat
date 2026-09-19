#!/usr/bin/env bash
# Lesson: tar -tf

LESSON_COMMAND="tar -tf"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Never extract an archive you have not looked inside.
  tar -tf papers.tar
'-t' lists the contents without unpacking anything. A badly made archive
can scatter files all over your current directory, and this is how you
find that out before it happens rather than afterwards."

TASK_INSTRUCTION="List what is inside papers.tar without extracting it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Now you know what it will do before you let it. Always look first."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use tar -tf on papers.tar."
TASK_FAIL_POSE="confused"

HINT_1="You want a table of contents, not the contents themselves."
HINT_2="The flag is -t, and -f still names the archive."
HINT_3="Type: tar -tf papers.tar"

check_task() {
    check_command_matches '^tar +-[a-zA-Z]*t[a-zA-Z]* +.*papers\.tar$'
}
