#!/usr/bin/env bash
# Review: substitution (S9) + wc (S2) + sed (S6) + redirect (S4)

TASK_INSTRUCTION="Write a single line that puts the number of lines in notes.md into a sentence in count.txt — using command substitution, not a pipe into a file."
TASK_CAT_POSE="thinking"
RECALLS="Stage 9 — \$( ) · Stage 2 — wc · Stage 4 — >"

TASK_SUCCESS_MSG="A command's output used as a word inside a sentence. That is the trick Stage 9 exists for."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="count.txt needs the number and some words around it, built with \$( )."
TASK_FAIL_POSE="confused"

HINT_1="The count is a command; you need it as text inside another command."
HINT_2="echo with \$(wc -l < notes.md) inside the string."
HINT_3="Run: echo notes has \$(wc -l < notes.md) lines > count.txt"

setup_challenge() {
    rm -f "${SANDBOX_HOME}/count.txt"
    printf 'one\ntwo\nthree\nfour\nfive\nsix\nseven\n' > "${SANDBOX_HOME}/notes.md"
}

check_task() {
    check_file_exists "count.txt" \
        && check_file_matches "count.txt" '7' \
        && check_file_matches "count.txt" '[A-Za-z]'
}
