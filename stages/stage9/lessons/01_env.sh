#!/usr/bin/env bash
# Lesson: env

LESSON_COMMAND="env"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="The shell carries a set of named values around with it, and
hands them to every program it starts. They are called environment variables.
  env
lists them all. You will see HOME, PATH, USER and a few dozen others.
Nothing here is magic. They are values with agreed names, and programs
look them up because everyone agreed to."

TASK_INSTRUCTION="List the environment your shell is carrying."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Every program you run inherits that list. It is how they know who you are and where home is."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Type env on its own."
TASK_FAIL_POSE="confused"

HINT_1="Three letters, short for environment."
HINT_2="The command is env."
HINT_3="Type: env"

check_task() {
    check_command_matches '^(env|printenv)$'
}
