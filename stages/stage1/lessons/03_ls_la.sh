#!/usr/bin/env bash
# Lesson: ls -la

LESSON_COMMAND="ls -la"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="thinking"

LESSON_CONTENT="Some things are hidden in Linux! Files starting with a dot (.) are invisible to a normal 'ls'.
Let's use 'ls -la' to see them all.
The '-l' means long listing (more details), and '-a' means all (including hidden).
Hmm... I wonder why some files start with '.'?"

TASK_INSTRUCTION="Run 'ls -la' and spot the difference from just 'ls'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Amazing! You found the hidden stuff. Those dot files are usually configuration files!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Make sure you add the '-la' flags after ls."
TASK_FAIL_POSE="confused"

HINT_1="You need to list things, but with all details and hidden files."
HINT_2="Add the -l and -a flags."
HINT_3="Type 'ls -la' and press Enter."

check_task() {
    # Both flags must be present, in either order or as separate arguments.
    check_command_matches '^ls +-[al]+$' || check_command_matches '^ls +-[al] +-[al]$'
}
