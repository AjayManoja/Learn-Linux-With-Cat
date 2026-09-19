#!/usr/bin/env bash
# Lesson: PID and PPID

LESSON_COMMAND="ps -o pid,ppid"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Every process has two numbers that matter.
  PID  - its own identity
  PPID - the PID of whatever started it
Every process except one has a parent, because the only way to make a
process is for an existing one to fork. PID 1 is the exception: init, or
systemd, started by the kernel itself. Everything else descends from it.
  ps -o pid,ppid,comm
picks exactly the columns you want instead of ps's default guess."

TASK_INSTRUCTION="Show the PID, PPID and command of the processes you are running."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Every PPID there points at whoever forked it. Follow them far enough and you reach PID 1."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use ps with -o and ask for pid, ppid and comm."
TASK_FAIL_POSE="confused"

HINT_1="ps can be told exactly which columns to print."
HINT_2="The flag is -o, followed by comma-separated column names."
HINT_3="Type: ps -o pid,ppid,comm"

check_task() {
    check_command_matches '^ps +.*-o.*ppid'
}
