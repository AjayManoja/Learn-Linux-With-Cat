#!/usr/bin/env bash
# Lesson: the shebang

LESSON_COMMAND="#!"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A script is a text file containing commands. One line makes it special:
  #!/usr/bin/env bash
That's the shebang, and it must be the very first line. It tells the system
which program should read the rest of the file.
Write one with the tools you already have — echo and a redirect."

TASK_INSTRUCTION="Create scripts/hello.sh whose first line is the shebang, using echo and >"
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="A file with a shebang. It isn't runnable yet — that's the next lesson."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="scripts/hello.sh needs '#!/usr/bin/env bash' as its first line."
TASK_FAIL_POSE="confused"

HINT_1="You already know how to put a line of text into a new file."
HINT_2="echo the shebang line and redirect it into scripts/hello.sh — quote it so the shell leaves it alone."
HINT_3="Type: echo '#!/usr/bin/env bash' > scripts/hello.sh"

check_task() {
    local f="${SANDBOX_HOME}/scripts/hello.sh"
    [[ -f "$f" ]] && head -1 "$f" | grep -q '^#!.*\(bash\|sh\)'
}
