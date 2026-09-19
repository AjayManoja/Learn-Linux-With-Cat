#!/usr/bin/env bash
# Lesson: SIGTERM vs SIGKILL

LESSON_COMMAND="kill -9"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="This distinction gets asked in interviews constantly.

  kill PID       sends SIGTERM. The process is asked to stop. It can save
                 its work, close files, flush buffers, then exit cleanly.

  kill -9 PID    sends SIGKILL. The kernel removes the process. It gets no
                 warning and no chance to clean up. Open files may be left
                 half-written; locks may be left held.

Always try SIGTERM first. Reach for -9 only when a process is ignoring it,
because -9 is how you get corrupted data."

TASK_INSTRUCTION="Start a background sleep, then stop it politely with a plain kill (SIGTERM)."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Politely asked, and it went. That should always be your first attempt."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Start a sleep in the background, then kill it without -9."
TASK_FAIL_POSE="confused"

HINT_1="A plain kill already sends the polite signal."
HINT_2="sleep 300 & gives you a PID; kill that PID with no flags."
HINT_3="Type: sleep 300 &   then: kill <the PID>"

check_task() {
    check_command_matches '^kill +[0-9]+$' && check_no_background_running
}
