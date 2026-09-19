#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Rewrite the Rules"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="The dog's list of privileges needs editing. ✏️
Take data/memo.txt and produce house_rules.txt where:
  - every 'dog' has become 'cat'
  - the line about the sofa is gone entirely
Two sed operations, one file out."
MISSION_SUCCESS_MSG="Substituted and deleted in one pass. The sofa is ours again."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Two separate sed jobs: one substitutes, one deletes."
HINT_2="You can pipe one sed into another, then redirect the result."
HINT_3="Run: sed 's/dog/cat/g' data/memo.txt | sed '/sofa/d' > house_rules.txt"

setup_mission() {
    rm -f "${SANDBOX_HOME}/house_rules.txt"
}

check_mission() {
    check_file_exists "house_rules.txt" \
        && check_file_matches "house_rules.txt" 'cat' \
        && ! check_file_matches "house_rules.txt" 'dog' \
        && ! check_file_matches "house_rules.txt" 'sofa'
}
