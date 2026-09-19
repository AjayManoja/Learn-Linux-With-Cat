#!/usr/bin/env bash
# Lesson: command substitution

LESSON_COMMAND="\$(...)"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="The last piece. '\$(command)' runs a command and replaces
itself with whatever that command printed.
  echo \"Today is \$(date)\"
The date runs first, its output goes into the string, then echo prints
the result. A pipe passes output to another command's input; substitution
turns output into an argument.
This is how a script fills in values it cannot know in advance."

TASK_INSTRUCTION="Use command substitution to print a sentence containing the output of whoami."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="The inner command ran first and its output became part of your sentence. That is the last piece of the shell."
TASK_SUCCESS_POSE="celebrate"

TASK_FAIL_MSG="Put \$(whoami) inside an echo."
TASK_FAIL_POSE="confused"

HINT_1="Run one command and use its output as text inside another."
HINT_2="The syntax is a dollar sign and round brackets."
HINT_3="Type: echo I am \$(whoami)"

check_task() {
    check_command_matches '^echo +.*\$\(.*\)'
}
