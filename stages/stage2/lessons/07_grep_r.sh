#!/usr/bin/env bash
# Lesson: grep -r

LESSON_COMMAND="grep -r"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="So far you have searched one file at a time.
The -r flag means 'recursive': search every file in a directory,
and every directory inside it, all the way down.
Give it a folder instead of a file and it goes hunting on its own."

TASK_INSTRUCTION="Search the whole inbox directory for the word 'garden'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="One command searched every letter in the inbox. That's the power of -r."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use grep -r on the inbox directory."
TASK_FAIL_POSE="confused"

HINT_1="You don't know which letter it's in, so search all of them."
HINT_2="The flag for searching a whole directory tree is -r."
HINT_3="Type: grep -r garden inbox"

check_task() {
    check_command_matches '^grep +.*-r.* +inbox/?$'
}
