#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Identify the Layers"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Prove you can see each layer for yourself. Three things:
  1. The kernel   - show its version
  2. The hardware - show the CPU the kernel is managing
  3. User space   - show where your shell lives on disk
Any order. Three commands, one per layer."
MISSION_SUCCESS_MSG="Kernel, hardware, user space. You can point at each one now instead of taking my word for it."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="One command per layer: the kernel reports itself, /proc reports the hardware, PATH finds your shell."
HINT_2="uname, then /proc/cpuinfo, then which."
HINT_3="Run: uname -a  /  cat /proc/cpuinfo  /  which bash"

LAYER_KERNEL=false
LAYER_CPU=false
LAYER_SHELL=false

setup_mission() {
    LAYER_KERNEL=false
    LAYER_CPU=false
    LAYER_SHELL=false
}

check_mission() {
    local last="${LAST_COMMAND:-}"
    [[ "$last" =~ ^uname ]] && LAYER_KERNEL=true
    [[ "$last" == *"/proc/cpuinfo"* ]] && LAYER_CPU=true
    [[ "$last" =~ ^(which|type|file)[[:space:]]+.*(bash|sh) ]] && LAYER_SHELL=true
    [[ "$LAYER_KERNEL" == true && "$LAYER_CPU" == true && "$LAYER_SHELL" == true ]]
}
