#!/usr/bin/env bash
# Lesson: find -type

LESSON_COMMAND="find -type"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="You know 'find . -name'. Names are only one thing to search by.
'-type f' finds regular files. '-type d' finds directories.
  find . -type d
lists every directory below you and no files at all.
This is how you answer 'what is the shape of this tree' rather than
'where is this one file'."

TASK_INSTRUCTION="List every directory below your home — directories only, no files."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The skeleton of your home, with the contents left out."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use find with -type d."
TASK_FAIL_POSE="confused"

HINT_1="find can filter by what a thing is, not only what it is called."
HINT_2="The flag is -type, and directories are d."
HINT_3="Type: find . -type d"

check_task() {
    check_command_matches '^find +.*-type +d'
}
