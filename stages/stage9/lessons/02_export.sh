#!/usr/bin/env bash
# Lesson: export

LESSON_COMMAND="export"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="You met variables in Stage 5: NAME=cat.
Those belong to your shell alone. 'export' promotes one into the
environment, so programs your shell starts can see it too:
  export CATNAME=Mochi
Without export, a script you run will not see the variable at all. That
is the whole difference, and it explains a great many confusing afternoons."

TASK_INSTRUCTION="Export a variable called CATNAME with any value you like."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Now it is part of the environment, not just your shell. Check it with env."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use export with CATNAME= and a value."
TASK_FAIL_POSE="confused"

HINT_1="Set a variable, but make it visible to other programs."
HINT_2="The keyword goes before the assignment."
HINT_3="Type: export CATNAME=Mochi"

check_task() {
    check_command_matches '^export +CATNAME=.+'
}
