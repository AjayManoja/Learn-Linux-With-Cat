#!/usr/bin/env bash
# Lesson: kill

LESSON_COMMAND="kill"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="You started something that won't stop for five minutes.
'kill' stops a process by its PID: 'kill 1234'.
Despite the name it's a polite request — the process is asked to shut
down and normally obliges. Use 'ps' to find the PID of that sleep,
then stop it.
(In this sandbox I'll only let you kill jobs the game itself started.)"

TASK_INSTRUCTION="Find the PID of your sleep with 'ps', then stop it with 'kill <PID>'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Stopped. Start things, find things, stop things — that's process control."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="The sleep is still running. Use 'ps' to get its PID, then kill it."
TASK_FAIL_POSE="confused"

HINT_1="First you need its number, then you need to stop it."
HINT_2="'ps' lists PIDs. 'kill' takes one."
HINT_3="Run 'ps', find the line saying sleep, and type: kill <that number>"

check_task() {
    check_no_background_running
}
