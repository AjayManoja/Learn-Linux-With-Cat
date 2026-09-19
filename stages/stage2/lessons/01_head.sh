#!/usr/bin/env bash
# Lesson: head

LESSON_COMMAND="head"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Some files are far too long to read with 'cat'.
The 'head' command shows you just the beginning — the first 10 lines by default.
Think of it as peeking at the top of a pile without knocking it over.
You can ask for a different number with -n, like 'head -n 3 file.txt'."

TASK_INSTRUCTION="Peek at the top of logs/system.log with 'head'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That's the top of the file. Much better than scrolling forever!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Not quite. I'm looking for 'head' on logs/system.log."
TASK_FAIL_POSE="confused"

HINT_1="You want the first few lines of a long file."
HINT_2="The command is 'head', and it takes a filename."
HINT_3="Type: head logs/system.log"

check_task() {
    check_command_matches '^head( +-n?[0-9]*)*( +-n +[0-9]+)? +(logs/)?system\.log$'
}
