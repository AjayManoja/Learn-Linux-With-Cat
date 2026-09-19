#!/usr/bin/env bash
# Lesson: process vs thread

LESSON_COMMAND="nproc"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A PROCESS has its own memory. Nothing it does can touch another
process's memory - that is the isolation from Stage 11.

A THREAD is a line of execution inside a process. Threads of the same
process SHARE that memory: the same variables, the same heap, the same
open files. Each has only its own stack and registers.

That sharing is the whole point, and the whole problem. Communication is
free because there is nothing to send. But two threads writing the same
variable is a bug waiting for the right timing.
  nproc
tells you how many can genuinely run at once."

TASK_INSTRUCTION="Find out how many CPUs this machine has - how many threads can truly run in parallel."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That is your real parallelism. More threads than that and they take turns."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run nproc."
TASK_FAIL_POSE="confused"

HINT_1="One command reports the CPU count."
HINT_2="The command is nproc."
HINT_3="Type: nproc"

check_task() {
    check_command_matches '^(nproc|getconf +_NPROCESSORS_ONLN)' \
        || check_command_matches '/proc/cpuinfo'
}
