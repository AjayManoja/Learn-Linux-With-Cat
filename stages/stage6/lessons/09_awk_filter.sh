#!/usr/bin/env bash
# Lesson: awk with a condition

LESSON_COMMAND="awk condition"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="awk can decide which lines to act on, which makes it a filter
and a formatter at once:
  awk -F: '\$3 > 5 {print \$1}' file
means 'where the third field is greater than 5, print the first'.
That is a grep and a cut in one command, and it understands numbers —
which grep never does, because to grep everything is text."

TASK_INSTRUCTION="From data/inventory.txt, print the names of items where the quantity — field 3 — is more than 5."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A numeric filter and a column selection in one line. This is where awk earns its keep."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="awk -F: with a condition on \$3 and a print of \$1."
TASK_FAIL_POSE="confused"

HINT_1="The condition goes before the braces, the action inside them."
HINT_2="awk -F: '\$3 > 5 {print \$1}' — that is the whole shape."
HINT_3="Type: awk -F: '\$3 > 5 {print \$1}' data/inventory.txt"

check_task() {
    check_command_matches '^awk +.*\$3 *> *5.*print.*\$1.* +.*inventory\.txt$'
}
