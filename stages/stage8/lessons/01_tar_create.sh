#!/usr/bin/env bash
# Lesson: tar -cf

LESSON_COMMAND="tar -cf"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="'tar' bundles many files into one. The name is short for
tape archive, which tells you how old it is.
  tar -cf papers.tar documents
'-c' creates, '-f' names the file. The archive comes first, then what
goes into it — that order catches people out.
An archive is not compressed. It is just a box with everything in it."

TASK_INSTRUCTION="Bundle the documents directory into an archive called papers.tar."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="One file where there were several. Check it with 'ls -l' — it is about the same size as its contents."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use tar -cf with papers.tar first and documents second."
TASK_FAIL_POSE="confused"

HINT_1="You want to create an archive from a directory."
HINT_2="-c creates and -f names the archive; the archive name comes first."
HINT_3="Type: tar -cf papers.tar documents"

check_task() {
    check_file_exists "papers.tar"
}
