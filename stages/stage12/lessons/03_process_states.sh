#!/usr/bin/env bash
# Lesson: process states

LESSON_COMMAND="ps -o stat"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A process is always in exactly one state, and ps prints it as
a letter in the STAT column:

  R  running, or ready to run
  S  sleeping - waiting for something, interruptible
  D  uninterruptible sleep - usually waiting on disk, cannot be killed
  T  stopped - suspended by a signal
  Z  zombie - finished, but not yet reaped by its parent

Most processes on a healthy machine are S. They are waiting for input that
has not arrived. A machine full of D is a machine with a disk problem."

TASK_INSTRUCTION="Show the state of every process you own, with its PID and command."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Mostly S - sleeping, waiting for something to happen. That is what a healthy system looks like."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use ps -o with stat among the columns."
TASK_FAIL_POSE="confused"

HINT_1="Ask ps for the state column."
HINT_2="The column is called stat."
HINT_3="Type: ps -o pid,stat,comm"

check_task() {
    check_command_matches '^ps +.*-o.*stat'
}
