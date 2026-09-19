#!/usr/bin/env bash
# Lesson: SIGSTOP and SIGCONT

LESSON_COMMAND="kill -STOP"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Not every signal ends a process. SIGSTOP freezes one where it
stands, and SIGCONT resumes it exactly where it left off.
  kill -STOP PID
  kill -CONT PID
A stopped process shows state T in ps. It uses no CPU, holds all its memory,
and keeps every file open. This is what Ctrl+Z does in your terminal.
Useful when something is eating the CPU and you want to look at it before
deciding whether to kill it."

TASK_INSTRUCTION="Start a background sleep, freeze it with SIGSTOP, then confirm its state is T with ps."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="State T - frozen, holding everything, using nothing. SIGCONT would wake it exactly where it stopped."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Send SIGSTOP to a background sleep, then check its state with ps."
TASK_FAIL_POSE="confused"

HINT_1="Start it, stop it, then look at its STAT column."
HINT_2="kill -STOP <PID>, then ps -o pid,stat -p <PID>"
HINT_3="Type: sleep 300 &  /  kill -STOP <PID>  /  ps -o pid,stat,comm"

check_task() {
    check_command_matches '^ps +.*stat' && check_command_matches 'ps'
}
