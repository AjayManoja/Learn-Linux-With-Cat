#!/usr/bin/env bash
# Lesson: cd ~

LESSON_COMMAND="cd ~"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="No matter how lost you get, you can always go home!
The tilde symbol (~) represents your home directory.
Typing 'cd ~' will immediately teleport you back to your home base."

TASK_INSTRUCTION="Try it: cd into 'projects', then use 'cd ~' to teleport home. Confirm with 'pwd'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Home sweet home! Now you have the whole navigation toolkit!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Did you use the tilde (~) symbol?"
TASK_FAIL_POSE="confused"

HINT_1="Use the teleport to home symbol."
HINT_2="It's cd followed by a tilde."
HINT_3="Type 'cd ~' and press Enter."

check_task() {
    if check_current_dir "/home/catplayer"; then
        return 0
    fi
    return 1
}
