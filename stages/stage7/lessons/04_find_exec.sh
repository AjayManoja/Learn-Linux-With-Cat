#!/usr/bin/env bash
# Lesson: find -exec

LESSON_COMMAND="find -exec"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Finding files is half the job. '-exec' does something to each one:
  find . -name \"*.md\" -exec wc -l {} \;
The '{}' is replaced by each file found, and the '\;' ends the command.
Both are required and both look strange — that is just the syntax.
Now a search can change things, not only list them."

TASK_INSTRUCTION="Find every .md file below your home and count the lines of each with wc -l."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A search that did something. That pair — {} and \; — is the whole trick."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="find with -name \"*.md\" and -exec wc -l {} \;"
TASK_FAIL_POSE="confused"

HINT_1="find can run a command on each thing it finds."
HINT_2="-exec takes the command, {} stands for the file, and \; ends it."
HINT_3="Type: find . -name \"*.md\" -exec wc -l {} \;"

check_task() {
    check_command_matches '^find +.*-exec +.*\{\}'
}
