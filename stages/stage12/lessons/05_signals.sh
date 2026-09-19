#!/usr/bin/env bash
# Lesson: signals

LESSON_COMMAND="kill -l"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'kill' does not kill. It sends a signal, and most signals are
requests the process can handle however it likes.
  kill -l
lists them all. The ones that matter:
  SIGTERM (15) - please shut down. The default.
  SIGKILL (9)  - stop immediately. Cannot be caught or ignored.
  SIGSTOP (19) - freeze. Also cannot be caught.
  SIGCONT (18) - carry on.
  SIGHUP  (1)  - terminal closed; many daemons treat it as 'reload config'.
The name is historical and misleading. Think 'send signal', not 'kill'."

TASK_INSTRUCTION="List every signal your system supports."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="About sixty of them. You will use four."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run kill with -l."
TASK_FAIL_POSE="confused"

HINT_1="kill can list what it is able to send."
HINT_2="The flag is -l, for list."
HINT_3="Type: kill -l"

check_task() {
    check_command_matches '^kill +-l'
}
