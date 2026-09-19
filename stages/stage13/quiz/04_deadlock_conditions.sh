#!/usr/bin/env bash
QUESTION="What is a deadlock, and how do you prevent one?"
QUESTION_HINT="Two threads, two locks, and a shape you can break."
ANSWER_PATTERN="(circular|each other|cycle)|(lock.*order|order.*lock)|hold.*wait|(wait.*(each other|forever))"
MODEL_ANSWER="A deadlock is two or more threads each holding a resource the other needs,
so none of them can ever proceed. Thread A holds lock 1 and wants lock 2; thread B
holds lock 2 and wants lock 1. Neither gives up.

Four conditions must all hold: mutual exclusion, hold-and-wait, no preemption, and
circular wait. Break any one and deadlock becomes impossible.

In practice you break circular wait by imposing a consistent lock ordering - every
thread acquires lock 1 before lock 2, always. It costs nothing at runtime. Other
options are lock timeouts, or acquiring everything at once and backing off entirely
if you cannot.

The dangerous part is that a deadlocked process uses no CPU and does not crash. It
just stops answering, while every metric says it is healthy."
