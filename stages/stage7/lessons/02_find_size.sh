#!/usr/bin/env bash
# Lesson: find -size

LESSON_COMMAND="find -size"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'-size' finds files by how big they are.
  find . -size +10k
finds everything larger than 10 kilobytes. The '+' means 'more than';
'-' means 'less than'; no sign means 'exactly'.
Suffixes: c for bytes, k for kilobytes, M for megabytes.
This is the first question to ask when something has filled up."

TASK_INSTRUCTION="Find every file below your home larger than 10 kilobytes."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The big ones, picked out without opening a single folder."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use find with -size and +10k."
TASK_FAIL_POSE="confused"

HINT_1="find can filter by size as well as name and type."
HINT_2="The flag is -size, and a leading + means 'larger than'."
HINT_3="Type: find . -size +10k"

check_task() {
    check_command_matches '^find +.*-size +\+[0-9]+[ckM]'
}
