#!/usr/bin/env bash
# Lesson: system calls

LESSON_COMMAND="syscall"
LESSON_TITLE="CAT SAYS"
LESSON_CAT_POSE="default"

LESSON_CONTENT="A system call is how user space asks the kernel for something.
It is the only door between the two.
  open()   read()   write()   fork()   execve()   exit()
When you run 'cat notes.txt', cat makes an open() call, then read() calls,
then write() calls. Roughly forty system calls for one short file.
Everything a program cannot do itself — touch a disk, a network, another
process — is a syscall. There is no other way through."

TASK_INSTRUCTION="Read /proc/self/status — the kernel describing the very process that is asking."
TASK_CAT_POSE="thinking"

TASK_SUCCESS_MSG="'self' means whoever is asking. The kernel filled that in for your command specifically."
TASK_SUCCESS_POSE="happy"

TASK_FAIL_MSG="Read /proc/self/status."
TASK_FAIL_POSE="confused"

HINT_1="/proc has a special entry meaning 'the process reading this'."
HINT_2="The path is /proc/self/status."
HINT_3="Type: cat /proc/self/status"

check_task() {
    check_command_matches '^(cat|less|head|grep) +.*/proc/self/status'
}
