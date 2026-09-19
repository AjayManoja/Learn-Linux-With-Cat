#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Trace the Family"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Find out where your own shell came from.
Show a process listing that includes both PID and PPID, and then read your
shell's parent out of /proc.
Two commands. The second one needs a real PID directory, not self."
MISSION_SUCCESS_MSG="You followed the chain upward. Keep going far enough and every process leads to PID 1."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="First list processes with their parents, then look one up under /proc."
HINT_2="ps -o pid,ppid,comm gives you a PID. Then cat /proc/<PID>/status."
HINT_3="Run: ps -o pid,ppid,comm   then: cat /proc/1/status"

FAMILY_PS=false
FAMILY_PROC=false

setup_mission() {
    FAMILY_PS=false
    FAMILY_PROC=false
}

check_mission() {
    local last="${LAST_COMMAND:-}"
    [[ "$last" =~ ^(ps|pstree).*ppid ]] && FAMILY_PS=true
    [[ "$last" =~ /proc/[0-9]+/status ]] && FAMILY_PROC=true
    [[ "$FAMILY_PS" == true && "$FAMILY_PROC" == true ]]
}
