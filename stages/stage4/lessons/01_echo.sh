#!/usr/bin/env bash
# Lesson: echo

LESSON_COMMAND="echo"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'echo' just prints whatever you give it.
On its own that sounds pointless — you typed the words, you know what they say.
Its value comes next: once you can produce output, you can redirect it,
and 'echo' is the simplest thing that produces output."

TASK_INSTRUCTION="Print a greeting with: echo meow"
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Straight back at you. Now let's send that somewhere more useful."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Try 'echo' followed by something to print."
TASK_FAIL_POSE="confused"

HINT_1="A command that repeats what you tell it."
HINT_2="The command is 'echo'."
HINT_3="Type: echo meow"

check_task() {
    check_command_matches '^echo +.+'
}
