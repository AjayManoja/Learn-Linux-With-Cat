#!/usr/bin/env bash
# Lesson: tar -czf

LESSON_COMMAND="tar -czf"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="Add 'z' and tar compresses as it bundles:
  tar -czf papers.tar.gz documents
That is the command you will actually use — bundle and squeeze in one go.
To unpack: tar -xzf papers.tar.gz.
The .tar.gz ending is a description, not magic: tarred, then gzipped.
You will also see it written .tgz, which means the same thing."

TASK_INSTRUCTION="Create a compressed archive of documents called papers.tar.gz."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="Bundled and compressed in one command. Compare it to papers.tar with ls -l."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Use tar with -czf and the name papers.tar.gz."
TASK_FAIL_POSE="confused"

HINT_1="Same as creating an archive, with one extra letter for compression."
HINT_2="The letter is z, and it goes with the c and f."
HINT_3="Type: tar -czf papers.tar.gz documents"

check_task() {
    check_file_exists "papers.tar.gz"
}
