#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="Prove It Arrived Intact"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="The full job, end to end. 🚚
1. Bundle documents/ into delivery.tar.gz, compressed.
2. Take a checksum of that archive and save it to delivery.sha256.
Anyone receiving both can now prove the archive is the one you sent.
This is exactly how software is shipped."
MISSION_SUCCESS_MSG="An archive and a proof of what is in it. That is how every release you have ever downloaded was published."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Two steps: make the archive, then fingerprint the archive itself."
HINT_2="tar -czf first, then sha256sum on the .tar.gz, redirected to a file."
HINT_3="Run: tar -czf delivery.tar.gz documents   then: sha256sum delivery.tar.gz > delivery.sha256"

setup_mission() {
    rm -f "${SANDBOX_HOME}/delivery.tar.gz" "${SANDBOX_HOME}/delivery.sha256"
}

check_mission() {
    check_file_exists "delivery.tar.gz" \
        && check_file_exists "delivery.sha256" \
        && check_file_matches "delivery.sha256" 'delivery\.tar\.gz' \
        && ( cd "${SANDBOX_HOME}" && sha256sum -c delivery.sha256 >/dev/null 2>&1 )
}
