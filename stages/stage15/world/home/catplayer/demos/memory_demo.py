#!/usr/bin/env python3
"""Reserve address space, then actually use it, and watch the difference.

Three numbers matter here:
  VSZ      virtual size - address space the process has reserved
  RSS      resident set size - how much of it is really in RAM
  minflt   minor page faults - times the kernel had to map in a page

Reserving address space is nearly free. RAM is only committed when you
touch a page, and that first touch is a page fault.
"""
import mmap
import os

PAGE = 4096
CHUNK = 64 * 1024 * 1024      # 64 MB per mapping
MAPPINGS = 4


def stats():
    vsz = rss = 0
    with open(f"/proc/{os.getpid()}/status") as f:
        for line in f:
            if line.startswith("VmSize:"):
                vsz = int(line.split()[1])
            elif line.startswith("VmRSS:"):
                rss = int(line.split()[1])
    with open(f"/proc/{os.getpid()}/stat") as f:
        minflt = int(f.read().split()[9])
    return vsz, rss, minflt


def report(label):
    vsz, rss, minflt = stats()
    print(f"{label:<34}{vsz:>12} kB{rss:>12} kB{minflt:>14}")


print(f"{'':34}{'VSZ':>15}{'RSS':>15}{'minor faults':>14}")
report("at start")

# mmap reserves address space without committing any memory to it.
maps = []
for i in range(1, MAPPINGS + 1):
    maps.append(mmap.mmap(-1, CHUNK))
    report(f"reserved {i * CHUNK // (1024*1024)} MB (untouched)")

print()
print("Address space went up by 256 MB. RSS barely moved, and almost no")
print("faults were taken - because nothing has been read or written yet.")
print()

# Touching one byte per page forces the kernel to map a real frame each time.
for m in maps:
    for offset in range(0, len(m), PAGE):
        m[offset] = 1

report("after touching every page")

print()
print("Now RSS has caught up and the fault count has jumped by roughly one")
print("per 4 KB page touched. Each of those was a MINOR page fault: the page")
print("was not mapped, the kernel found a free frame and mapped it, and your")
print("program carried on without noticing.")
print()
print("A MAJOR fault is the expensive one - the page had to be read from")
print("disk. Those are what make a swapping machine feel broken.")

for m in maps:
    m.close()
