#!/usr/bin/env bash
# Lesson: find -name

LESSON_COMMAND="find -name"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Listing everything is rarely what you want.
'-name' filters by filename: find . -name \"notes.txt\"
The quotes matter once you use a star: \"*.log\" means 'anything ending
in .log'. That star is a wildcard, and it stands for any run of characters."

TASK_INSTRUCTION="Find every file ending in .log below your home directory."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Two log files, located without opening a single folder."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use find with -name and a *.log pattern."
TASK_FAIL_POSE="confused"

HINT_1="You want files whose names end a particular way."
HINT_2="'find . -name' takes a pattern. A star matches anything."
HINT_3="Type: find . -name \"*.log\""

check_task() {
    check_command_matches '^find +.*-name +.*\*\.log'
}
