#!/usr/bin/env bash
# Lesson: pwd

LESSON_COMMAND="pwd"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Welcome to the terminal! Let's find out where you are.
The 'pwd' command stands for Print Working Directory.
Think of it like checking your current location on a map.
It tells you exactly which folder you are currently standing in."

TASK_INSTRUCTION="Run 'pwd' to see your current location."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Purrfect! You are in /home/catplayer. That's your home base!"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Hmm, that doesn't look like pwd. Try again!"
TASK_FAIL_POSE="confused"

HINT_1="Think of checking your location."
HINT_2="It's a navigation command for 'print working directory'."
HINT_3="Type 'pwd' and press Enter."

check_task() {
    # Check if the player ran pwd and it shows /home/catplayer
    if check_command_output "pwd" | grep -q "/home/catplayer"; then
        return 0
    fi
    return 1
}
