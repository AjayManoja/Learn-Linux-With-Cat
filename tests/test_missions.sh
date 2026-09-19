#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/world/sandbox.sh"
source "$REPO_ROOT/src/world/filesystem.sh"
source "$REPO_ROOT/src/world/maze.sh"
source "$REPO_ROOT/src/engine/checker.sh"
source "$REPO_ROOT/src/engine/hints.sh"

echo "Testing Stage 1 missions..."

MISSIONS_DIR="$REPO_ROOT/stages/stage1/missions"

# Every mission must be winnable. The regression these guard against is a
# check_mission that no sequence of legal commands can ever satisfy.

# ── nav_mission ────────────────────────────────────────────
create_sandbox 1 >/dev/null
source "$MISSIONS_DIR/nav_mission.sh"
setup_mission

CURRENT_GAME_DIR="$SANDBOX_HOME"
assert_fails "nav: not complete while standing at home" check_mission
assert_path_exists "nav: the note exists where the maze put it" \
    "$SANDBOX_HOME/$NAV_NOTE_DIR/note.txt"
assert_ok "nav: hint 3 names the real location" \
    grep -qF "$NAV_NOTE_DIR" <<< "$HINT_3"

# The player's only legal move is to cd there.
CURRENT_GAME_DIR="$SANDBOX_HOME/$NAV_NOTE_DIR"
assert_ok "nav: complete once the player reaches the note" check_mission
destroy_sandbox

# ── file_mission ───────────────────────────────────────────
create_sandbox 1 >/dev/null
source "$MISSIONS_DIR/file_mission.sh"
setup_mission

assert_fails "file: not complete before tidying" check_mission
assert_path_exists "file: important.txt laid down" "$SANDBOX_HOME/important.txt"
assert_path_exists "file: old_notes.txt laid down" "$SANDBOX_HOME/old_notes.txt"
assert_path_exists "file: junk.txt laid down"      "$SANDBOX_HOME/junk.txt"

mkdir -p "$SANDBOX_HOME/organized"
cp "$SANDBOX_HOME/important.txt" "$SANDBOX_HOME/organized/important.txt"
mv "$SANDBOX_HOME/old_notes.txt" "$SANDBOX_HOME/archive.txt"
rm -f "$SANDBOX_HOME/junk.txt"
assert_ok "file: complete after the four steps" check_mission
destroy_sandbox

# ── hidden_cat_mission ─────────────────────────────────────
create_sandbox 1 >/dev/null
source "$MISSIONS_DIR/hidden_cat_mission.sh"
setup_mission

CURRENT_GAME_DIR="$SANDBOX_HOME"
assert_fails "fish: not complete the moment the maze is built" check_mission
assert_path_exists "fish: fish.txt exists at the final spot" \
    "$SANDBOX_HOME/$HIDDEN_FISH_DIR/fish.txt"
assert_path_exists "fish: mission code written for check.sh" "$GAME_ROOT/.mission_code"
assert_ok "fish: the code in fish.txt matches check.sh's copy" \
    grep -qF "$(cat "$GAME_ROOT/.mission_code")" "$SANDBOX_HOME/$HIDDEN_FISH_DIR/fish.txt"

CURRENT_GAME_DIR="$SANDBOX_HOME/$HIDDEN_FISH_DIR"
assert_ok "fish: complete once the player reaches the fish" check_mission
destroy_sandbox

# ── stage 3: the vault, after the player has used chmod on it ───────────────
# Stage 3 teaches chmod and then asks the player to practise it. Locking the
# directory a mission stages its files in is a reasonable thing to try, and it
# used to leave setup_mission unable to write there — which, because mission
# scripts carry their own `set -e`, killed the session outright.
create_sandbox 3 >/dev/null
populate_stage_files 3 >/dev/null 2>&1 || true
source "$REPO_ROOT/stages/stage3/missions/vault_mission.sh"

assert_ok "vault: setup works on a clean world" setup_mission

# The state that crashed the game: locked directory, unreadable file inside.
chmod 400 "$SANDBOX_HOME/vault"
assert_ok "vault: setup recovers from a locked directory" setup_mission
assert_ok "vault: the directory is usable again" test -w "$SANDBOX_HOME/vault"
assert_eq "vault: the file is locked again for the player"     "0" "$(stat -c %a "$SANDBOX_HOME/vault/treats.txt")"

# And the mission is still winnable from there.
CURRENT_GAME_DIR="$SANDBOX_HOME"
LAST_COMMAND="cat vault/treats.txt"
assert_fails "vault: still locked before the player unlocks it" check_mission
chmod 600 "$SANDBOX_HOME/vault/treats.txt"
assert_ok "vault: completes once unlocked and read" check_mission

# A locked home must not shut the player out either.
chmod 000 "$SANDBOX_HOME/vault" 2>/dev/null || true
assert_ok "ensure_sandbox_dir reopens a fully locked directory"     ensure_sandbox_dir "$SANDBOX_HOME/vault"
assert_fails "ensure_sandbox_dir refuses paths outside the sandbox"     ensure_sandbox_dir "/etc"

destroy_sandbox

finish "Mission tests"
