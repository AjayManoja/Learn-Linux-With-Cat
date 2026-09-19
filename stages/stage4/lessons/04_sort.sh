#!/usr/bin/env bash
# Lesson: sort

LESSON_COMMAND="sort"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'sort' puts lines in order. That's all it does, and it's enough.
The important part: it doesn't change the file. It reads the lines,
orders them, and prints the result. The original stays as it was.
Commands that read input and print a changed version are called filters,
and they are what pipes are for."

TASK_INSTRUCTION="Sort the lines of data/sightings.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Ordered — and the file on disk is untouched. Check it with 'cat' if you doubt me."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run 'sort' on data/sightings.txt."
TASK_FAIL_POSE="confused"

HINT_1="One command, named after exactly what it does."
HINT_2="'sort' takes a filename."
HINT_3="Type: sort data/sightings.txt"

check_task() {
    check_command_matches '^sort +.*sightings\.txt$'
}
