#!/usr/bin/env python3
"""fork() makes a copy of the running process.

Both processes continue from the same line. The only way to tell them apart
is the return value: the child gets 0, the parent gets the child's PID.
"""
import os

print(f"before fork: I am PID {os.getpid()}")

pid = os.fork()

if pid == 0:
    print(f"  child : PID {os.getpid()}, my parent is {os.getppid()}")
    os._exit(0)
else:
    os.waitpid(pid, 0)
    print(f"  parent: PID {os.getpid()}, my child was {pid}")
    print("\nOne process became two. Nothing was loaded from disk to do it.")
