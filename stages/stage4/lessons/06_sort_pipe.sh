#!/usr/bin/env bash
# Lesson: sort | uniq -c

LESSON_COMMAND="sort | uniq -c"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Now put it together.
'uniq' only spots neighbours, so sort first and the duplicates line up:
  sort data/sightings.txt | uniq -c
That counts how many times each animal appears. Two ordinary commands,
joined by a pipe, and you have a tally nobody wrote a program for.
This pattern — sort, then uniq -c — is one you'll use constantly."

TASK_INSTRUCTION="Count each animal in data/sightings.txt by piping sort into uniq -c."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A frequency count, built from two commands and a pipe. That's the whole philosophy."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Pipe 'sort' into 'uniq -c'."
TASK_FAIL_POSE="confused"

HINT_1="uniq needs its duplicates adjacent. Something can arrange that first."
HINT_2="sort the file, then pipe the result into uniq -c."
HINT_3="Type: sort data/sightings.txt | uniq -c"

check_task() {
    check_command_matches '^sort +.*sightings\.txt *\| *uniq +.*-c'
}
