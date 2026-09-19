#!/usr/bin/env bash
# Lesson: reading the permission string

LESSON_COMMAND="ls -l"
# Where the player must be standing for these instructions to make sense.
LESSON_START_DIR="work"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Time to decode it. Take -rw-r--r-- and split it up:
  -    what it is (- a file, d a directory)
  rw-  what the OWNER can do: read, write, not execute
  r--  what the GROUP can do: read only
  r--  what EVERYONE ELSE can do: read only
Three letters, three times. r is read, w is write, x is execute,
and a dash means 'not allowed'."

TASK_INSTRUCTION="Run 'ls -l report.txt' and read its permission string."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Owner, group, everyone else. You can read any file's rules now."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="List just report.txt in long format."
TASK_FAIL_POSE="confused"

HINT_1="You want the long listing of one particular file."
HINT_2="'ls -l' takes a filename."
HINT_3="Type: ls -l report.txt"

check_task() {
    check_command_matches '^ls +-[la]*l[la]* +.*report\.txt$'
}
