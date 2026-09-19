#!/usr/bin/env bash
# Lesson: > redirection

LESSON_COMMAND=">"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Here's the second big idea of this game, after the pipe.
The '>' symbol sends a command's output into a file instead of the screen.
  echo meow > note.txt
Nothing prints. The words went into the file.
One warning that matters: '>' replaces the file's contents completely.
If note.txt already had something in it, it's gone."

TASK_INSTRUCTION="Write your name into a new file: echo <your name> > owner.txt"
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Silence on the screen, because the words went into the file. Read it with 'cat'."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Redirect an echo into owner.txt using >"
TASK_FAIL_POSE="confused"

HINT_1="Point the output of echo at a file."
HINT_2="The symbol is '>', and the filename goes after it."
HINT_3="Type: echo catplayer > owner.txt"

check_task() {
    check_file_exists "owner.txt"
}
