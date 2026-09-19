#!/usr/bin/env bash
# Lesson: wc

LESSON_COMMAND="wc"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="How big is that file, exactly?
'wc' counts things: lines, words and characters.
'wc -l file.txt' gives you just the line count, which is usually what you want.
Now you can measure a file before deciding how to read it."

TASK_INSTRUCTION="Count the lines in logs/system.log using 'wc -l'."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Hundreds of lines! Aren't you glad you didn't 'cat' it?"
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="I'm after 'wc -l' on logs/system.log."
TASK_FAIL_POSE="confused"

HINT_1="'wc' stands for word count, but it counts lines too."
HINT_2="The flag for lines is -l."
HINT_3="Type: wc -l logs/system.log"

check_task() {
    check_command_matches '^wc +-l +(logs/)?system\.log$'
}
