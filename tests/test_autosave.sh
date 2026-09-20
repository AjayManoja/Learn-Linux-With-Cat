#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/engine/progress.sh"

echo "Testing autosave and crash safety..."

select_player_profile "crashtest" || true

# ── The save is written whole, or not at all ───────────────

CURRENT_STAGE=6
save_progress
assert_eq "the save holds what was in memory" \
    "6" "$(progress_field "$PROGRESS_FILE" CURRENT_STAGE)"
assert_eq "no half-written file is left behind" \
    "0" "$(find "$GAME_ROOT/.catgame" -name '*.new.*' | wc -l | tr -d ' ')"
assert_eq "every field the game reloads is in it" "13" \
    "$(wc -l < "$PROGRESS_FILE" | tr -d ' ')"

# ── A save that would change nothing is not written ────────
# Every command typed at the prompt calls through save_progress. Rewriting
# the same bytes hundreds of times a session is only more chances to be
# interrupted in the middle of one. The marker below survives exactly as
# long as nothing rewrites the file.

printf '# marker\n' >> "$PROGRESS_FILE"
save_progress
assert_ok "an unchanged save is left alone" grep -q '^# marker$' "$PROGRESS_FILE"

HINTS_USED=3
save_progress
assert_fails "a changed save is written out" grep -q '^# marker$' "$PROGRESS_FILE"
assert_eq "with the change in it" "3" "$(progress_field "$PROGRESS_FILE" HINTS_USED)"

rm -f "$PROGRESS_FILE"
save_progress
assert_path_exists "a deleted save is written again, unchanged or not" "$PROGRESS_FILE"

# ── How it is written ──────────────────────────────────────
# The live save is never the file being written to: the new contents go
# somewhere else and are renamed over it, so there is no moment where the
# save on disk is a file that has been truncated and not yet filled in.
# Catching that by killing the game mid-write is a race; catching the rename
# is not.

MOVED_FROM=""
mv() { MOVED_FROM="${*: -2:1}"; command mv "$@"; }
CURRENT_SECTION="C"
save_progress
unset -f mv

assert_eq "the new contents are renamed into place, not written in place" \
    "${PROGRESS_FILE}.new.$$" "$MOVED_FROM"

# ── Signals ────────────────────────────────────────────────
# The window closing (HUP), Ubuntu shutting down (TERM) and Ctrl-C (INT) can
# all still be answered, and the answer is to write the save before going.

# Runs the game's save path in a child, sends it one signal, and reports the
# stage that ended up on disk.
stage_after_signal() {
    local signal="$1"
    local root="$TEST_ROOT/signal_${signal}"

    mkdir -p "$root"
    (
        export GAME_ROOT="$root"
        # shellcheck disable=SC1090
        source "$REPO_ROOT/src/engine/progress.sh"
        select_player_profile "crashtest" || true
        install_save_traps
        CURRENT_STAGE=11
        # Announce readiness only once the new stage is un-saved in memory,
        # so the save on disk can only have come from the trap.
        printf 'ready\n' > "$root/ready"
        sleep 30
    ) &
    local child=$!

    local waited=0
    while [[ ! -f "$root/ready" && "$waited" -lt 100 ]]; do
        sleep 0.1
        waited=$((waited + 1))
    done

    kill "-${signal}" "$child" 2>/dev/null || true
    wait "$child" 2>/dev/null || true

    progress_field "$root/.catgame/crashtest.progress" CURRENT_STAGE
}

assert_eq "the save is written when the terminal window closes" \
    "11" "$(stage_after_signal HUP)"
assert_eq "the save is written when the system shuts the game down" \
    "11" "$(stage_after_signal TERM)"
assert_eq "the save is written on Ctrl-C" \
    "11" "$(stage_after_signal INT)"

# ── A crash with no warning at all ─────────────────────────
# SIGKILL answers nothing, which is as close as a test gets to the power
# going out. Killed in the middle of a run of saves, the file on disk still
# has to be one whole save — the previous one or the new one, never half of
# either. Where the kill lands is a race, so this runs a few times.

kill_during_saves() {
    local root="$TEST_ROOT/kill9_$1"
    mkdir -p "$root"
    (
        export GAME_ROOT="$root"
        # shellcheck disable=SC1090
        source "$REPO_ROOT/src/engine/progress.sh"
        select_player_profile "crashtest" || true
        local n=0
        while true; do
            n=$((n + 1))
            CURRENT_STAGE="$n"
            COMMANDS_PRACTICED="pwd ls cd cat grep find chmod ps top df du $n"
            save_progress
        done
    ) >/dev/null 2>&1 &
    local child=$!

    sleep 0.7
    kill -9 "$child" 2>/dev/null || true
    wait "$child" 2>/dev/null || true

    printf '%s' "$root/.catgame/crashtest.progress"
}

whole_saves=0
readable_saves=0
for round in 1 2 3; do
    killed_save="$(kill_during_saves "$round")"
    [[ "$(wc -l < "$killed_save" | tr -d ' ')" == "13" ]] && whole_saves=$((whole_saves + 1))
    bash -c "source '$killed_save'" 2>/dev/null && readable_saves=$((readable_saves + 1))
done

assert_eq "a save killed outright is still a whole save, every time" \
    "3" "$whole_saves"
assert_eq "and still one the game can read" "3" "$readable_saves"

finish "Autosave tests"
