#!/usr/bin/env bash
# Lesson: du piped into sort

LESSON_COMMAND="du | sort"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="The real question is never 'how big is this' but 'what is
biggest'. du prints in whatever order it walks the tree, so sort it:
  du -h media/* | sort -h
'-h' on sort means 'understand human sizes' — so 2K sorts before 1M,
which a plain alphabetic sort gets badly wrong.
This is Stage 4's sort meeting Stage 7's du. Old command, new use."

TASK_INSTRUCTION="List the contents of media by size, smallest to largest, using du piped into sort -h."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Ordered by size. 'What is eating my disk' is now one command away."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Pipe du into sort -h."
TASK_FAIL_POSE="confused"

HINT_1="du can list each item; something else puts them in order."
HINT_2="sort needs -h too, or it will sort 9K after 10M."
HINT_3="Type: du -h media/* | sort -h"

check_task() {
    check_command_matches '^du +.*\| *sort +.*-h'
}
