#!/usr/bin/env bash
# Lesson: basename and dirname

LESSON_COMMAND="basename"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Two small tools that matter enormously inside scripts.
  basename /home/catplayer/site/pages.txt   gives  pages.txt
  dirname  /home/catplayer/site/pages.txt   gives  /home/catplayer/site
When a loop hands you a full path and you only want the filename — to
build an output name, or print something readable — basename is the answer.
Without it you end up doing unpleasant things with cut."

TASK_INSTRUCTION="Use basename to get just the filename from site/pages.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Just the name, no path. In a loop over find's output, this is what you want nine times in ten."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run basename on site/pages.txt."
TASK_FAIL_POSE="confused"

HINT_1="You want the last part of a path."
HINT_2="The command is basename and it takes a path."
HINT_3="Type: basename site/pages.txt"

check_task() {
    check_command_matches '^basename +.*pages\.txt'
}
