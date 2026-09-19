#!/usr/bin/env bash
QUESTION="What does the nice value do, and why can only root set a negative one?"
QUESTION_HINT="A high value means being nice to other processes."
ANSWER_PATTERN="(nice.*(priorit|lower|higher))|(-20|19)|(root|sudo|privileg).*(negative|higher)|negative.*(root|sudo|privileg)"
MODEL_ANSWER="Nice values run from -20 (greediest) to 19 (most generous), with 0 the
default. A higher nice value means lower priority - literally being nicer to
everything else. It biases the scheduler; it does not reserve or cap CPU.

Only root can set a negative value, because otherwise every user would set -20 on
their own work and the scale would mean nothing. Raising your own niceness is
allowed; lowering it again is not, even back to where it started.

Practical use: nice -n 19 on a backup or a build so it yields to anything
interactive, and renice on a job that is already running and hurting."
