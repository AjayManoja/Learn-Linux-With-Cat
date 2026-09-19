#!/usr/bin/env bash
# Lesson: tr

LESSON_COMMAND="tr"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'tr' swaps characters for other characters, one for one.
  tr a-z A-Z
turns everything upper case. 'tr : ,' turns colons into commas.
It is the only one of these tools that cannot read a file by name — it
only reads a pipe. So you will always see it downstream of something else."

TASK_INSTRUCTION="Pipe data/inventory.txt through tr to turn every colon into a comma."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Colons in, commas out. And 'tr' only works on a pipe — remember that."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Pipe the file into tr and swap ':' for ','."
TASK_FAIL_POSE="confused"

HINT_1="tr cannot open a file itself. Something has to feed it."
HINT_2="cat the file and pipe it into tr with the two characters."
HINT_3="Type: cat data/inventory.txt | tr : ,"

check_task() {
    check_command_matches '\| *tr +' && check_command_matches 'inventory\.txt'
}
