#!/usr/bin/env bash
# Lesson: which

LESSON_COMMAND="which"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'which' answers the question PATH raises: which one did it pick?
  which grep
prints the full path of the program that would actually run.
When two versions of something are installed and the wrong one keeps
running, this is the command that tells you why."

TASK_INSTRUCTION="Find out where the grep command actually lives."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That is the exact file that runs when you type grep. PATH found it first."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run which on grep."
TASK_FAIL_POSE="confused"

HINT_1="The command asks the question literally."
HINT_2="which takes the name of a command."
HINT_3="Type: which grep"

check_task() {
    check_command_matches '^(which|type) +[a-zA-Z]+'
}
