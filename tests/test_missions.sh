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

finish "Mission tests"
