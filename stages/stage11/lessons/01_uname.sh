#!/usr/bin/env bash
# Lesson: uname

LESSON_COMMAND="uname"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Start at the bottom. 'Linux' is the kernel — one program that
owns the hardware and arbitrates everything else.
  uname -a
prints its name, version and architecture. Everything you have done in ten
stages has been a request to that one program.
Ubuntu, Debian, Alpine: those are distributions. The kernel underneath is
the same Linux."

TASK_INSTRUCTION="Show which kernel you are actually running, with all details."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That is the kernel. One program, underneath everything you have typed so far."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run uname with -a."
TASK_FAIL_POSE="confused"

HINT_1="One command reports the system's identity."
HINT_2="uname, with a flag meaning 'all'."
HINT_3="Type: uname -a"

check_task() {
    check_command_matches '^uname( +-[a-zA-Z]+)+'
}
