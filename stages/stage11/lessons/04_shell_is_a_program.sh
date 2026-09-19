#!/usr/bin/env bash
# Lesson: the shell is just a program

LESSON_COMMAND="which bash"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="The shell is not part of Linux. It is an ordinary program that
happens to read your typing and start other programs.
  which bash
gives you a file on disk. You could delete it and the kernel would not
notice. Replace it with zsh or fish and nothing underneath changes.
That is the whole shape of the system:

  hardware → kernel → user space → shell → your commands

Each layer only talks to the one below it."

TASK_INSTRUCTION="Show that your shell is just a file on disk — find where bash lives."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A file, like any other. Nothing special about it except what it does."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use which (or type) on bash."
TASK_FAIL_POSE="confused"

HINT_1="You learned the command for this in Stage 9."
HINT_2="which locates a program."
HINT_3="Type: which bash"

check_task() {
    check_command_matches '^(which|type|file) +.*(bash|sh)'
}
