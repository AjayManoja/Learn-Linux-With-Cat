#!/usr/bin/env bash
# Lesson: ls -l

LESSON_COMMAND="ls -l"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="You've used 'ls -la' to see hidden files. Now look at what else it prints.
Each line starts with something like -rw-r--r--
That string is the file's permissions, and by the end of this stage
you'll read it as easily as a name."

TASK_INSTRUCTION="Run 'ls -l' in the work directory and look at the left-hand column."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Those letters on the left are the whole subject of this stage."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Move into 'work' and run 'ls -l' there."
TASK_FAIL_POSE="confused"

HINT_1="You need to be inside the work directory first."
HINT_2="cd work, then list it in long format."
HINT_3="Type: cd work    then: ls -l"

check_task() {
    check_current_dir "work" && check_command_matches '^ls +-[la]*l[la]*$'
}
