#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/ui/colors.sh"
source "$REPO_ROOT/src/engine/progress.sh"
source "$REPO_ROOT/src/engine/history.sh"

echo "Testing command history and line editing..."

# ── Where a player's history lives ─────────────────────────

select_player_profile "Ada Lovelace" || true
assert_eq "history sits beside the player's own save" \
    "${GAME_ROOT}/.catgame/ada_lovelace.history" "$(player_history_file)"

# The legacy single-save path is not a .progress file. Deriving a name from
# it would have handed back the save's own path and written history over it.
saved_progress_file="$PROGRESS_FILE"
PROGRESS_FILE="$LEGACY_PROGRESS_FILE"
assert_eq "the legacy save is never used as a history file" \
    "${GAME_ROOT}/.catgame/catplayer.history" "$(player_history_file)"
PROGRESS_FILE="$saved_progress_file"

# ── Remembering what was typed ─────────────────────────────

init_command_history
remember_command "pwd"
remember_command "ls -la"
remember_command "ls -la"
remember_command "cd toys"

assert_eq "each command is stored once, repeats collapsed" \
    "pwd
ls -la
cd toys" "$(cat "$(player_history_file)")"

assert_eq "the newest command is the first one back" "cd toys" "$(history -p '!!' 2>/dev/null || true)"

# A command starting with a dash is an option to the history builtin unless
# it is fenced off, and the whole call used to fail on it.
remember_command "-- weird"
assert_eq "a command starting with a dash is still stored" \
    "-- weird" "$(tail -n 1 "$(player_history_file)")"

# ── Carrying it into the next session ──────────────────────

HISTORY_LAST=""
init_command_history
assert_eq "last session's commands are loaded back" \
    "-- weird" "$(history -p '!!' 2>/dev/null || true)"

remember_command "-- weird"
assert_eq "a reload does not duplicate the command it ended on" \
    1 "$(grep -c -- '-- weird' "$(player_history_file)")"

# ── The file stays bounded ─────────────────────────────────

HISTORY_LIMIT=10
: > "$(player_history_file)"
for i in $(seq 1 25); do
    printf 'echo %s\n' "$i" >> "$(player_history_file)"
done
init_command_history
assert_eq "an overlong history is trimmed to the newest entries" \
    "10" "$(wc -l < "$(player_history_file)" | tr -d ' ')"
assert_eq "and it is the newest that survive" \
    "echo 25" "$(tail -n 1 "$(player_history_file)")"
HISTORY_LIMIT=500

# ── Reading a line without a terminal ──────────────────────

# The test suite has no terminal, so read_line must fall back to the plain
# read it replaced: same prompt on stdout, same line in the same variable.
assert_fails "readline is off without a terminal" prompt_can_edit

typed=""
out="$(read_line "cat@linux:~$ " typed <<< "echo hello"; printf '|%s' "$typed")"
assert_eq "the prompt is printed and the line is read" "cat@linux:~$ |echo hello" "$out"

# Colour in a prompt is left bare for the plain read; only readline needs the
# \001…\002 fencing, and only readline understands it.
assert_eq "colour is not fenced when readline is not reading" \
    "$(printf '\033[0;32m')" "$(prompt_color '\033[0;32m')"
assert_eq "and an empty colour adds nothing at all" "" "$(prompt_color '')"

finish "history"
