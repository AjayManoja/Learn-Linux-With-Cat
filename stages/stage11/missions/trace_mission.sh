#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Catch a Process in the Act"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I want to see a process described by the kernel itself.
Start a background job that sleeps, then read that process's own directory
under /proc - its status file specifically.
You will need its PID, and you already know how to get one."
MISSION_SUCCESS_MSG="You read the kernel's own record of a live process. That is all ps has ever done."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Start something long-running, find its PID, then look it up under /proc."
HINT_2="A background sleep prints its PID. Then read /proc/<that PID>/status."
HINT_3="Run: sleep 300 &   then: cat /proc/<the PID it printed>/status"

setup_mission() {
    :
}

check_mission() {
    # A numbered PID directory, not /proc/self: the point is inspecting a
    # process other than the one doing the asking.
    check_command_matches '^(cat|less|head|grep) +.*/proc/[0-9]+/status'
}
