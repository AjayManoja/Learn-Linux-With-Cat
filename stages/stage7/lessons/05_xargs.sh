#!/usr/bin/env bash
# Lesson: xargs

LESSON_COMMAND="xargs"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Some commands read from a pipe. Most do not — 'rm', 'wc' and
'chmod' want their filenames as arguments, and a pipe cannot supply those.
'xargs' bridges the gap: it turns lines of input into arguments.
  find . -name \"*.md\" | xargs wc -l
It is usually faster than -exec, because it passes many files to one
command instead of running the command once per file."

TASK_INSTRUCTION="Do the same count again, but pipe find into xargs instead of using -exec."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Same answer, one invocation instead of many. Now you know both ways."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Pipe your find into 'xargs wc -l'."
TASK_FAIL_POSE="confused"

HINT_1="wc cannot read filenames from a pipe. Something has to convert them."
HINT_2="Pipe find's output into xargs, and give xargs the command."
HINT_3="Type: find . -name \"*.md\" | xargs wc -l"

check_task() {
    check_command_matches '^find +.*\| *xargs +'
}
