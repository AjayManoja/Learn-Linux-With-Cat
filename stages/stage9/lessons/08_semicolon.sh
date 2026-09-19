#!/usr/bin/env bash
# Lesson: ;

LESSON_COMMAND=";"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A semicolon runs commands one after another regardless of
whether they worked:
  pwd ; ls ; whoami
Three commands, three results, no conditions. Use it when the steps are
independent.
Know the difference and you can say exactly what you mean:
  ;  means 'then'
  && means 'and only if that worked'
  || means 'or else'"

TASK_INSTRUCTION="Run pwd and ls one after the other on a single line, separated by a semicolon."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Both ran, unconditionally. Three ways to join commands, and you now know all of them."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Put pwd and ls on one line with a semicolon between them."
TASK_FAIL_POSE="confused"

HINT_1="One character separates two commands that do not depend on each other."
HINT_2="It is the semicolon."
HINT_3="Type: pwd ; ls"

check_task() {
    check_command_matches '^pwd *; *ls' || check_command_matches '^ls *; *pwd'
}
