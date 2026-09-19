#!/usr/bin/env bash
# Lesson: nice

LESSON_COMMAND="nice"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="You can bias the real scheduler. NICE values run from -20 to 19,
and the name is literal: a high nice value means being nice to everyone else.

  nice -n 10 command   start it with low priority
  renice 5 -p PID      change a running process

Lower is greedier. Negative values need root, because letting any user
outrank everyone else would defeat the point.

This is the honest tool for 'this backup is slowing the machine down'. It
does not stop the job - it just makes it yield whenever anything else wants
the CPU."

TASK_INSTRUCTION="Start a background sleep with a nice value of 10."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Lower priority, still running. It will now lose every contest against a normal process - which is exactly what you want for background work."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use nice with -n 10 on a background sleep."
TASK_FAIL_POSE="confused"

HINT_1="nice goes in front of the command you want to slow down."
HINT_2="nice -n 10 <command>, with an & to background it."
HINT_3="Type: nice -n 10 sleep 60 &"

check_task() {
    check_command_matches '^nice +.*-n *[0-9]+'
}
