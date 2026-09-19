#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Is This Machine Busy?"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Answer it properly, which means two numbers, not one.
  1. Show the load average
  2. Show how many CPUs there are
A load of 4 means nothing until you know whether there are 2 cores or 32."
MISSION_SUCCESS_MSG="Load without a core count is meaningless. You now always fetch both."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="One command for load, one for the core count."
HINT_2="uptime and nproc."
HINT_3="Run: uptime   then: nproc"

LOAD_SEEN=false
CORES_SEEN=false

setup_mission() {
    LOAD_SEEN=false
    CORES_SEEN=false
}

check_mission() {
    local last="${LAST_COMMAND:-}"
    [[ "$last" =~ ^uptime || "$last" == *"/proc/loadavg"* ]] && LOAD_SEEN=true
    [[ "$last" =~ ^nproc || "$last" == *"/proc/cpuinfo"* ]] && CORES_SEEN=true
    [[ "$LOAD_SEEN" == true && "$CORES_SEEN" == true ]]
}
