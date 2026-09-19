#!/usr/bin/env python3
"""exec() replaces the running process with a different program.

Notice the PID does not change, and nothing after the exec call runs -
there is no "after" any more. The process is now a different program.
"""
import os

print(f"I am PID {os.getpid()}, running python3")
print("calling exec to become /bin/echo ...\n")

os.execv("/bin/echo", ["echo", "   ...and now I am echo. Same PID, different program."])

print("THIS LINE NEVER RUNS")
