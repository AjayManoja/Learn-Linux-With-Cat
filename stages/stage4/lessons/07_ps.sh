#!/usr/bin/env bash
# Lesson: ps

LESSON_COMMAND="ps"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Every command you run is a process — a program the system is
currently executing. Most finish so fast you never see them.
'ps' lists the processes running right now. Each has a PID, a process id:
a number the system uses to refer to it. That number is how you talk
about a process, and in two lessons you'll use one to stop something."

TASK_INSTRUCTION="List the processes running right now with 'ps'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Those numbers on the left are PIDs. Remember them — you'll need one shortly."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Type 'ps' to see the running processes."
TASK_FAIL_POSE="confused"

HINT_1="Two letters, short for process status."
HINT_2="The command is 'ps'."
HINT_3="Type: ps"

check_task() {
    check_command_matches '^ps( +-?[a-zA-Z]+)*$'
}
