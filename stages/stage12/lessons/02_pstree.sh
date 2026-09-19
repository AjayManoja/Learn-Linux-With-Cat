#!/usr/bin/env bash
# Lesson: pstree

LESSON_COMMAND="pstree"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="PPIDs describe a tree, so draw it.
  pstree
shows the whole family from PID 1 downwards. Your shell is in there, and
anything you have started is hanging off it.
This is the fastest way to answer 'what started this?' - which is usually
the real question when something unexpected is running."

TASK_INSTRUCTION="Draw the process tree with pstree."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="One tree, rooted at PID 1. Everything running descends from it."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run pstree."
TASK_FAIL_POSE="confused"

HINT_1="One command draws the parent-child relationships."
HINT_2="The command is pstree."
HINT_3="Type: pstree"

check_task() {
    check_command_matches '^pstree'
}
