#!/usr/bin/env bash
# Lesson: grep -n

LESSON_COMMAND="grep -n"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Finding a line is good. Knowing where it lives is better.
The -n flag puts the line number in front of every match.
That way you can tell someone 'look at line 273' instead of
'it's somewhere in the middle, good luck'."

TASK_INSTRUCTION="Find the ERROR lines in logs/system.log with their line numbers."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Now you know exactly where each problem sits in the file."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Add the -n flag to your grep on logs/system.log."
TASK_FAIL_POSE="confused"

HINT_1="You want the position of each match, not just the text."
HINT_2="The flag for line numbers is -n."
HINT_3="Type: grep -n ERROR logs/system.log"

check_task() {
    check_command_matches '^grep +.*-n.* +(logs/)?system\.log$'
}
