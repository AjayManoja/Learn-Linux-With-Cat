#!/usr/bin/env bash
# Lesson: cut -d -f

LESSON_COMMAND="cut -d -f"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Counting characters is fragile — names have different lengths.
Most real data is separated by a character instead: commas, colons, tabs.
  cut -d: -f1 file
'-d' says what separates the fields, '-f' says which ones you want.
This is how you pull one column out of a CSV without writing a program."

TASK_INSTRUCTION="Print just the first field of data/inventory.txt — the items, which are separated by colons."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="One clean column. That is the shape most data arrives in."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use cut with -d: and -f1 on data/inventory.txt."
TASK_FAIL_POSE="confused"

HINT_1="The fields are separated by colons, and you want the first one."
HINT_2="-d says the separator, -f says the field number."
HINT_3="Type: cut -d: -f1 data/inventory.txt"

check_task() {
    check_command_matches '^cut +.*-d.*-f *1 +.*inventory\.txt$'
}
