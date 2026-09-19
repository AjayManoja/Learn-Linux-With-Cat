#!/usr/bin/env bash
# Lesson: free

LESSON_COMMAND="free -h"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Start with the summary.
  free -h
Five columns matter:
  total     all the RAM there is
  used      in use by processes
  free      genuinely untouched
  buff/cache  holding recently used file contents
  available   what a new program could actually get

The one people misread is 'free'. A healthy Linux machine has very little
free, because unused RAM is wasted RAM - the kernel fills it with cache.
The number to watch is AVAILABLE, which counts cache the kernel would
happily give back."

TASK_INSTRUCTION="Show the memory summary in human-readable units."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Note how little is 'free' and how much is available. Those are very different questions."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run free with -h."
TASK_FAIL_POSE="confused"

HINT_1="One command summarises memory, and takes the same -h you know from du."
HINT_2="The command is free."
HINT_3="Type: free -h"

check_task() {
    check_command_matches '^free' || check_command_matches '/proc/meminfo'
}
