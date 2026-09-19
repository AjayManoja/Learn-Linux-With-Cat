#!/usr/bin/env python3
"""Makes an orphan: a child whose parent dies first.

An orphan is NOT a problem. The kernel immediately re-parents it to init
(PID 1), which will reap it properly when it finishes. Compare that with a
zombie, where the parent is alive but negligent.

The child writes its parent's PID to orphan_report.txt twice: once while
its real parent is alive, and once after it has died.
"""
import os, time

report = os.path.join(os.getcwd(), "orphan_report.txt")

pid = os.fork()

if pid == 0:
    with open(report, "w") as f:
        f.write(f"child PID: {os.getpid()}\n")
        f.write(f"parent while alive: {os.getppid()}\n")
        f.flush()
        time.sleep(2)
        f.write(f"parent after it exited: {os.getppid()}\n")
        f.write("\nThe parent changed. The kernel re-parented me.\n")
        f.write("A process whose parent died is an orphan - and it gets adopted.\n")
    os._exit(0)

print(f"parent {os.getpid()} exiting immediately, leaving child {pid} an orphan")
print(f"in 3 seconds, read orphan_report.txt to see who adopted it")
os._exit(0)
