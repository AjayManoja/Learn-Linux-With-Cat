#!/usr/bin/env bash
# Lesson: df

LESSON_COMMAND="df"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'du' measures files. 'df' measures the disk they sit on.
  df -h
shows every filesystem, its size, how much is used and what is left.
When something says 'no space left on device', df tells you whether that
is true and du tells you who is responsible. They are a pair."

TASK_INSTRUCTION="Show the free space on this system in human-readable form."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="du for files, df for filesystems. Together they answer every space question."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run df with -h."
TASK_FAIL_POSE="confused"

HINT_1="Two letters, short for disk free."
HINT_2="Same -h flag as du."
HINT_3="Type: df -h"

check_task() {
    check_command_matches '^df( +-[a-zA-Z]+)*$'
}
