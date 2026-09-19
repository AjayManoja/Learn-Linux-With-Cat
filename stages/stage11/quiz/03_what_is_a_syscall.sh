#!/usr/bin/env bash
QUESTION="What is a system call? Give two examples."
QUESTION_HINT="It is the only door between your program and the kernel."
ANSWER_PATTERN="(request|ask|interface|call).*(kernel|os)|kernel.*(service|request)|open|read|write|fork|exec"
MODEL_ANSWER="A system call is a request from a user-space program to the kernel. It is
the only mechanism by which a program can do something it is not permitted to do
itself.

Common ones: open() and read() for files, write() for output, fork() to create a
process, execve() to replace one, exit() to end it, socket() for networking.

Running 'cat notes.txt' is roughly forty system calls: open the file, read it in
chunks, write each chunk to stdout, close it, exit. Every one crosses into kernel
space and back."
