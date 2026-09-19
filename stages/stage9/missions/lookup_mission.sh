#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Where Does It Come From?"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Three questions about your own shell. Answer all three: 🔎
  1. Show the whole environment.
  2. Print the PATH on its own.
  3. Show which file runs when you type sort.
Any order. I will know when all three are done."
MISSION_SUCCESS_MSG="Environment, search path, and the exact file it found. You can now explain why any command does what it does."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="One command lists the environment, one prints a variable, one locates a program."
HINT_2="env, then echo with the PATH variable, then which."
HINT_3="Run: env / echo \$PATH / which sort"

LOOKUP_ENV=false
LOOKUP_PATH=false
LOOKUP_WHICH=false

setup_mission() {
    LOOKUP_ENV=false
    LOOKUP_PATH=false
    LOOKUP_WHICH=false
}

check_mission() {
    local last="${LAST_COMMAND:-}"
    [[ "$last" =~ ^(env|printenv)$ ]]      && LOOKUP_ENV=true
    [[ "$last" =~ \$PATH ]]                && LOOKUP_PATH=true
    [[ "$last" =~ ^(which|type)\ +sort ]]  && LOOKUP_WHICH=true

    [[ "$LOOKUP_ENV" == true && "$LOOKUP_PATH" == true && "$LOOKUP_WHICH" == true ]]
}
