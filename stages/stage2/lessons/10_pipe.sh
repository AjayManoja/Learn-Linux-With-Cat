#!/usr/bin/env bash
# Lesson: the pipe

LESSON_COMMAND="|"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Here is the idea that makes Linux click.
The '|' symbol — a pipe — takes the output of one command and feeds it
straight into the next one, instead of printing it to the screen.
'grep ERROR logs/system.log | wc -l' searches, then counts the results.
Small commands, joined together, become one big one."

TASK_INSTRUCTION="Count how many ERROR lines are in logs/system.log by piping grep into wc -l."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="You just built a tool that didn't exist a second ago. That's the pipe."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Pipe your grep into 'wc -l' using the | symbol."
TASK_FAIL_POSE="confused"

HINT_1="You know how to find the lines, and how to count lines. Join them."
HINT_2="The | symbol sends one command's output into the next."
HINT_3="Type: grep ERROR logs/system.log | wc -l"

check_task() {
    check_command_matches '^grep +.*\| *wc +-l'
}
