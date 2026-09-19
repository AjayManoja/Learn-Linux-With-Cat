#!/usr/bin/env bash
QUESTION="What is the difference between SIGTERM and SIGKILL, and which should you use first?"
QUESTION_HINT="One is a request. The other is not."
ANSWER_PATTERN="(sigterm|15|term).*(catch|handle|clean|graceful|polite|ignore|request)|(sigkill|9|kill).*(cannot|immediate|force|not.*(caught|ignored))"
MODEL_ANSWER="SIGTERM (15) is the default for kill. It is a polite request: the process
receives it, and can run a handler to flush buffers, close files, release locks and
exit cleanly. It can also choose to ignore it.

SIGKILL (9) cannot be caught, blocked or ignored. The kernel removes the process
immediately. It gets no chance to clean up, so files can be left half-written and
locks left held.

Always send SIGTERM first and give it a few seconds. Use SIGKILL only when the
process is not responding - it is how you get corrupted state. SIGSTOP is the other
signal that cannot be caught, but it freezes rather than kills."
