#!/usr/bin/env bash
QUESTION="Walk me through what happens when you type ls and press Enter."
QUESTION_HINT="Six steps, starting at the shell and ending with characters on screen."
ANSWER_PATTERN="(fork|child).*exec|exec.*(fork|child)|path.*(search|look|find)|syscall|system call"
MODEL_ANSWER="1. The shell reads the line and splits it into a command and arguments.
2. It searches PATH, directory by directory, until it finds an executable ls.
3. It calls fork(), producing a child process identical to itself.
4. The child calls execve() on /usr/bin/ls, replacing itself with that program.
5. ls makes system calls - openat() on the directory, getdents64() to read the
   entries, write() to put them on stdout. The kernel checks permissions each time.
6. ls calls exit(). The kernel reaps it, and the shell, which was waiting, prints
   the next prompt.

The shell survived because what got replaced was the fork, not the shell itself."
