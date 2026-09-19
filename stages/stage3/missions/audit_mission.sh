#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Permission Audit"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Before you change any locks, learn to read them. 🔍
Three files in work/ have different permissions.
Inspect all three — report.txt, draft.txt and secrets.txt —
and find out which one nobody but its owner can read."
MISSION_SUCCESS_MSG="Audited. You can now tell at a glance who can touch what."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="You have two commands that show permissions: one brief, one detailed."
HINT_2="'ls -l <file>' or 'stat <file>' — inspect each of the three."
HINT_3="Run: ls -l report.txt / ls -l draft.txt / ls -l secrets.txt"

AUDIT_REPORT=false
AUDIT_DRAFT=false
AUDIT_SECRETS=false

setup_mission() {
    AUDIT_REPORT=false
    AUDIT_DRAFT=false
    AUDIT_SECRETS=false
}

check_mission() {
    local last="${LAST_COMMAND:-}"
    if [[ "$last" =~ ^(ls +-[la]*l[la]*|stat) ]]; then
        [[ "$last" == *report.txt*  ]] && AUDIT_REPORT=true
        [[ "$last" == *draft.txt*   ]] && AUDIT_DRAFT=true
        [[ "$last" == *secrets.txt* ]] && AUDIT_SECRETS=true
    fi
    [[ "$AUDIT_REPORT" == true && "$AUDIT_DRAFT" == true && "$AUDIT_SECRETS" == true ]]
}
