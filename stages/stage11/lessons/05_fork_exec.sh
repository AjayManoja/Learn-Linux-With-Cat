#!/usr/bin/env bash
# Lesson: fork and exec

LESSON_COMMAND="fork/exec"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Here is the thing that surprises people: Linux has no
'run this program' call. It has two calls, and you need both.

  fork()  — copy the current process. Now there are two, identical.
  exec()  — replace this process with a different program.

So your shell forks itself, and the copy execs into ls. That is why the
shell survives: the thing that got replaced was the copy.
Run the demo and watch one process become two."

TASK_INSTRUCTION="Run demos/fork_demo.py and watch a process split in half."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Two PIDs from one program, and no disk was touched to do it. That is fork."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run it with: python3 demos/fork_demo.py"
TASK_FAIL_POSE="confused"

HINT_1="It is a Python program in the demos directory."
HINT_2="Run it with python3."
HINT_3="Type: python3 demos/fork_demo.py"

check_task() {
    check_command_matches '^python3? +.*fork_demo\.py'
}
