#!/usr/bin/env bash
# Lesson: grep -i

LESSON_COMMAND="grep -i"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Careful: 'grep' is fussy about capital letters.
Searching for 'error' will not find 'ERROR'. That trips up everyone once.
The -i flag means 'ignore case', so it matches either way.
When a search comes back empty, this is the first thing to try."

TASK_INSTRUCTION="Search library/naps.txt for 'SUNBEAM' while ignoring case."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Found it, even though the file spells it in lowercase!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use grep with the -i flag on library/naps.txt."
TASK_FAIL_POSE="confused"

HINT_1="The file spells it differently from how you typed it."
HINT_2="There's a grep flag that ignores capital letters."
HINT_3="Type: grep -i SUNBEAM library/naps.txt"

check_task() {
    check_command_matches '^grep +-i.* +(library/)?naps\.txt$'
}
