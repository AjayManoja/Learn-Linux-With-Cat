#!/usr/bin/env bash
# Lesson: kernel space vs user space

LESSON_COMMAND="/proc/cpuinfo"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="The machine runs in two modes.

  USER SPACE   — your shell, ls, python, everything you write.
                 Cannot touch hardware. Cannot see other processes' memory.
  KERNEL SPACE — the kernel. Full access to everything.

Your programs cannot cross that line by themselves. When ls needs to read a
directory it has to ask.
/proc is the kernel answering questions in the form of files that do not
exist on any disk."

TASK_INSTRUCTION="Read /proc/cpuinfo — a file the kernel invents when you look at it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That file is not on your disk. The kernel produced it the moment you asked."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use cat on /proc/cpuinfo."
TASK_FAIL_POSE="confused"

HINT_1="It is a file, so read it the way you read any file."
HINT_2="The path is /proc/cpuinfo."
HINT_3="Type: cat /proc/cpuinfo"

check_task() {
    check_command_matches '^(cat|less|head|grep) +.*/proc/cpuinfo'
}
