#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Take a Backup"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Everything in documents/ needs backing up properly. 📦
Make a compressed archive called backup.tar.gz containing the whole
documents directory.
Compressed, not just bundled — one command does both."
MISSION_SUCCESS_MSG="Bundled and compressed. That single file is now the whole directory, portable."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Create, compress and name, all in one tar command."
HINT_2="The flags are c, z and f together."
HINT_3="Run: tar -czf backup.tar.gz documents"

setup_mission() {
    rm -f "${SANDBOX_HOME}/backup.tar.gz"
}

check_mission() {
    check_file_exists "backup.tar.gz" \
        && tar -tzf "${SANDBOX_HOME}/backup.tar.gz" 2>/dev/null | grep -q 'charter\.txt'
}
