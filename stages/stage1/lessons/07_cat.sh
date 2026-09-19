#!/usr/bin/env bash
# Lesson: cat

LESSON_COMMAND="cat"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Yes, I'm a cat teaching you the cat command. Meow.
The 'cat' command displays the contents of a file right in your terminal.
Don't confuse them: 'cat' is for reading files, while 'cd' is for entering folders."

TASK_INSTRUCTION="Use 'ls' to find welcome.txt, then use 'cat' to read it."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Well done! You read your first file."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Oops, did you use 'cat welcome.txt'?"
TASK_FAIL_POSE="confused"

HINT_1="First use ls to see what's there, then use the command with my name."
HINT_2="Use cat on the text file."
HINT_3="Type 'cat welcome.txt' and press Enter."

check_task() {
    check_command_matches '^cat +welcome\.txt$'
}
