#!/usr/bin/env bash
# Lesson: awk fields

LESSON_COMMAND="awk"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'awk' splits every line into fields and numbers them.
\$1 is the first field, \$2 the second, \$0 is the whole line.
  awk '{print \$2}' file
prints the second word of every line. By default it splits on spaces;
'-F:' tells it to split on colons instead, like cut's -d.
Where cut takes columns, awk can rearrange and combine them."

TASK_INSTRUCTION="Use awk with -F: to print the item and its location — fields 1 and 4 — from data/inventory.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Two fields, reordered and printed together. cut cannot do that."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="awk -F: with a print of \$1 and \$4 on data/inventory.txt."
TASK_FAIL_POSE="confused"

HINT_1="Tell awk the separator, then print the two fields you want."
HINT_2="-F: sets the separator; {print \$1, \$4} prints both."
HINT_3="Type: awk -F: '{print \$1, \$4}' data/inventory.txt"

check_task() {
    check_command_matches '^awk +.*-F.*print.*\$1.*\$4.* +.*inventory\.txt$'
}
