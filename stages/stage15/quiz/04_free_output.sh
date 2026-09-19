#!/usr/bin/env bash
QUESTION="free -h shows almost no free memory. Is that a problem? Which number should you look at?"
QUESTION_HINT="What is the kernel doing with all that RAM, and how quickly could it stop?"
ANSWER_PATTERN="(cache|buff).*(reclaim|free|release|give)|available|(not.*(problem|bad|issue))|unused.*wasted"
MODEL_ANSWER="It is almost certainly not a problem. Linux fills unused RAM with the page
cache, holding file contents in case they are read again. Unused memory is wasted
memory, so a healthy machine has very little 'free'.

Cache is immediately reclaimable. When a process needs memory the kernel drops cache
pages and hands the frames straight over - no disk write needed, because the data is
already on disk.

The number to look at is AVAILABLE. It estimates what a new process could actually
get: free memory plus the cache the kernel would release. If available is healthy,
the machine is fine no matter how small 'free' looks.

Alarms set on 'free' rather than 'available' are one of the most common monitoring
mistakes there is."
