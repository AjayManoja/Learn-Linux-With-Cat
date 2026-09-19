#!/usr/bin/env bash
# Lesson: sha256sum

LESSON_COMMAND="sha256sum"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A checksum is a fingerprint of a file's contents.
  sha256sum charter.txt
prints a long hex string. Change one character in the file and the string
changes completely. Change nothing and it is identical, every time, on
every machine.
That is why downloads publish checksums: you can prove you got the file
they sent without comparing it to theirs byte by byte."

TASK_INSTRUCTION="Take the checksum of documents/charter.txt."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="That string is the file's identity. Two files with the same one are the same file."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Run sha256sum on documents/charter.txt."
TASK_FAIL_POSE="confused"

HINT_1="You want a fingerprint of the contents."
HINT_2="The command names the algorithm: sha256sum."
HINT_3="Type: sha256sum documents/charter.txt"

check_task() {
    check_command_matches '^(sha256sum|md5sum) +.*charter\.txt$'
}
