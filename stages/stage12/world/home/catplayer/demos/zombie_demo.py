#!/usr/bin/env python3
"""Makes a real zombie process, on purpose.

A zombie is a process that has finished but whose parent has not collected
its exit status. The kernel keeps the entry so the parent can still ask
"how did it go?" - so the child is dead but not gone.

This parent deliberately never calls wait(). Look at the child with ps and
you will see state Z.
"""
import os, sys, time

pid = os.fork()

if pid == 0:
    # The child does nothing and exits immediately.
    os._exit(0)

print(f"parent PID  : {os.getpid()}")
print(f"child PID   : {pid}   <- this one is now a zombie")
print()
print("The child has exited. I am deliberately NOT calling wait() on it,")
print("so the kernel must keep its exit status around. That entry is the zombie.")
print()
print(f"In another moment, run:   ps -o pid,ppid,stat,comm -p {pid}")
print("Look at the STAT column. Z means zombie.")
print()
print("Waiting 30 seconds, then I will reap it and the zombie disappears.")
sys.stdout.flush()

time.sleep(30)
os.waitpid(pid, 0)
print("reaped - the zombie is gone")
