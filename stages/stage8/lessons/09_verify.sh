#!/usr/bin/env bash
# Lesson: verifying against a published checksum

LESSON_COMMAND="sha256sum -c"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A checksum on its own proves nothing — you have to compare it
to one you trust. sha256sum can do the comparison for you:
  sha256sum -c charter.sha256
reads a file of 'checksum  filename' lines, recomputes each, and prints OK
or FAILED. This is the last step of every careful download, and it is the
whole reason the previous lesson exists."

TASK_INSTRUCTION="Verify documents/charter.txt against the published checksum in charter.sha256."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="OK means the bytes are exactly what was promised. Now you can trust a file you did not watch arrive."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use sha256sum with -c on charter.sha256."
TASK_FAIL_POSE="confused"

HINT_1="sha256sum can check as well as compute."
HINT_2="The flag is -c, and it takes the checksum file."
HINT_3="Type: sha256sum -c charter.sha256"

setup_lesson() {
    ( cd "${SANDBOX_HOME}" && sha256sum documents/charter.txt > charter.sha256 ) 2>/dev/null || true
}

check_task() {
    check_command_matches '^(sha256sum|md5sum) +.*-c.*\.(sha256|md5)$'
}
