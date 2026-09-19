#!/usr/bin/env bash
QUESTION="What is a critical section, and how does a mutex protect it?"
QUESTION_HINT="One is a piece of code; the other is what stops two threads being in it."
ANSWER_PATTERN="(critical section.*(shared|one thread|at a time|exclusive))|mutex.*(one|exclusive|lock|at a time)|mutual exclusion"
MODEL_ANSWER="A critical section is a region of code that must not be executed by more
than one thread at a time - typically because it reads and then writes shared state.

A mutex (mutual exclusion lock) enforces that. A thread acquires it before entering
and releases it on the way out; any other thread that tries to acquire it blocks
until it is free.

Note what a mutex does not do: it does not make the operations atomic. The
read-modify-write is still three steps. It just guarantees no other thread holding
that lock can be running those steps at the same time.

The cost is contention. A lock held across slow work serialises everything waiting
on it, so hold it for as short a time as you can."
