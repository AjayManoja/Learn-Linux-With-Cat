#!/usr/bin/env bash
# Lesson: tee

LESSON_COMMAND="tee"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A redirect sends output to a file and you see nothing.
Sometimes you want both. 'tee' splits the stream:
  ls | tee listing.txt
prints the listing AND writes it to the file. The name is from a T-shaped
pipe fitting, which is exactly what it does.
Add -a to append instead of overwrite, like >> does."

TASK_INSTRUCTION="List your home directory, showing the output on screen and saving it to listing.txt at the same time."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Output in two places at once. Useful whenever you want to watch a long job and keep the log."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Pipe ls into tee with a filename."
TASK_FAIL_POSE="confused"

HINT_1="A redirect would hide the output. You want it visible as well as saved."
HINT_2="Pipe into tee and give tee the filename."
HINT_3="Type: ls | tee listing.txt"

check_task() {
    check_command_matches '\| *tee +' && check_file_exists "listing.txt"
}
