#!/usr/bin/env bash
# Lesson: ln -s

LESSON_COMMAND="ln -s"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A symbolic link is a file that points at another file.
  ln -s projects/notes.md shortcut.md
creates shortcut.md, which opens notes.md when you read it.
It is not a copy — there is still only one real file, and changing it
through either name changes the same thing. Delete the link and the
original is untouched. Delete the original and the link dangles."

TASK_INSTRUCTION="Create a symbolic link called shortcut.md that points at projects/notes.md."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="One file, two names. Check it with 'ls -l' — the arrow gives it away."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use ln -s with the target first and the link name second."
TASK_FAIL_POSE="confused"

HINT_1="The command makes a link; the -s makes it symbolic."
HINT_2="Target first, then the name you want for the link."
HINT_3="Type: ln -s projects/notes.md shortcut.md"

check_task() {
    [[ -L "${SANDBOX_HOME}/shortcut.md" ]]
}
