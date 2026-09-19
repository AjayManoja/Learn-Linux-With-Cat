#!/usr/bin/env bash
# Lesson: cut -c

LESSON_COMMAND="cut"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'cut' takes a slice out of every line.
'cut -c1-5 file' gives you characters 1 to 5 of each line and throws the
rest away. It is the bluntest of the text tools and sometimes exactly right.
Like sort and grep, it prints the result and leaves the file alone."

TASK_INSTRUCTION="Show only the first 6 characters of each line in data/inventory.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A column carved straight out of the middle of a file."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use cut with -c and a character range on data/inventory.txt."
TASK_FAIL_POSE="confused"

HINT_1="You want a fixed slice of characters from every line."
HINT_2="The flag for characters is -c, and it takes a range like 1-6."
HINT_3="Type: cut -c1-6 data/inventory.txt"

check_task() {
    check_command_matches '^cut +-c *[0-9]+-[0-9]+ +.*inventory\.txt$'
}
