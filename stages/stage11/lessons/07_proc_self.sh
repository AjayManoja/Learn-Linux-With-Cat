#!/usr/bin/env bash
# Lesson: reading a process from /proc

LESSON_COMMAND="/proc/PID"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Every running process has a directory under /proc named after
its PID. Inside:
  status   — state, parent, memory, user
  cmdline  — the exact command line it was started with
  fd/      — every file it currently has open
This is how ps works. It is not magic: it reads /proc and formats it.
Anything ps can tell you, you can read yourself."

TASK_INSTRUCTION="Show the command line of your own shell by reading /proc/self/cmdline."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="You just read a process's own memory description out of a filesystem that does not exist on disk."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Read /proc/self/cmdline."
TASK_FAIL_POSE="confused"

HINT_1="Same /proc/self directory, different file."
HINT_2="The file is cmdline."
HINT_3="Type: cat /proc/self/cmdline"

check_task() {
    check_command_matches '^(cat|less|head|tr|strings) +.*/proc/self/cmdline'
}
