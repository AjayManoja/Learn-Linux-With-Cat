#!/usr/bin/env bash
# Lesson: background jobs with &

LESSON_COMMAND="&"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Normally a command holds the terminal until it finishes.
Put '&' at the end and it runs in the background instead — you get your
prompt back immediately and the command carries on behind you.
'sleep 300 &' starts something that will sit there for five minutes.
Try it, then look for it with 'ps'. It really is still running."

TASK_INSTRUCTION="Start a long sleep in the background: sleep 300 &"
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Your prompt came straight back, but that process is alive. Find it with 'ps'."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run 'sleep 300 &' — the ampersand at the end is what matters."
TASK_FAIL_POSE="confused"

HINT_1="You want the command to run without blocking you."
HINT_2="A single character at the end of the line does it."
HINT_3="Type: sleep 300 &"

check_task() {
    check_background_running
}
