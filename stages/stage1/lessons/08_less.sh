#!/usr/bin/env bash
# Lesson: less

LESSON_COMMAND="less"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="For big files, 'cat' scrolls by too fast. That's when we use 'less'.
'less' shows you the file one screen at a time.
You can use arrows to scroll, and press 'q' to quit when you're done reading."

TASK_INSTRUCTION="Find the secret line inside system.log using 'less'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="You found it! Remember: 'cat' for small files, 'less' for big files."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Make sure you're using 'less' on the file."
TASK_FAIL_POSE="confused"

HINT_1="Use the command for reading large files."
HINT_2="Read system.log with less."
HINT_3="Type 'less system.log' and press Enter."

check_task() {
    # auto-pass after running less on system.log
    return 0
}
