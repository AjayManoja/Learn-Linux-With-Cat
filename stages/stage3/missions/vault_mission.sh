#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Locked Vault"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="I locked my treat stash and forgot how to get back in. 🗝️
There's a file in vault/ that even I can't read — I set it to 000,
which means nobody is allowed anything.
Here's the thing: you still OWN it, and an owner can always change
the permissions back. Unlock it, then read what's inside."
MISSION_SUCCESS_MSG="Locked out by your own file, and you talked your way back in. That's ownership."
MISSION_SUCCESS_POSE="celebrate"
HINT_1="Try reading it first and watch it refuse. Then ask why."
HINT_2="You own the file, so chmod still works on it even at 000."
HINT_3="Run: chmod 600 vault/treats.txt   then: cat vault/treats.txt"

VAULT_OPENED=false

setup_mission() {
    VAULT_OPENED=false
    mkdir -p "${SANDBOX_HOME}/vault"
    cat > "${SANDBOX_HOME}/vault/treats.txt" <<'TREATS'
THE STASH

Third shelf, behind the cereal.
The humans have never once looked there.
TREATS
    chmod 000 "${SANDBOX_HOME}/vault/treats.txt" 2>/dev/null || true
}

check_mission() {
    # Two things must both be true: the file is readable again, and the player
    # actually read it. Unlocking alone is half the lesson.
    if [[ -r "${SANDBOX_HOME}/vault/treats.txt" ]] \
        && [[ "${LAST_COMMAND:-}" =~ ^(cat|head|tail|less)\ +.*treats\.txt ]]; then
        VAULT_OPENED=true
    fi
    [[ "$VAULT_OPENED" == true ]]
}
