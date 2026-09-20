#!/usr/bin/env bash
set -euo pipefail

# Bump this when a save written by an older version needs repairing on load.
PROGRESS_FORMAT_CURRENT=3

# Saves live one per player, under .catgame/. A single shared save meant the
# second person to type their name at the title screen resumed the first
# person's stage, hints and completed lessons.
PROGRESS_DIR="${GAME_ROOT:-.}/.catgame"
# Where versions before per-player saves kept the one and only save.
LEGACY_PROGRESS_FILE="${GAME_ROOT:-.}/.catgame_progress"
# select_player_profile repoints this; until then it is the legacy path, which
# is what callers that never pick a player expect.
PROGRESS_FILE="$LEGACY_PROGRESS_FILE"

# Every value save_progress writes, back to its starting state. Switching
# profiles in one session has to clear the previous one, or anything missing
# from the new save would be inherited from it.
reset_progress_state() {
    CURRENT_STAGE=1
    CURRENT_SECTION="A"
    CURRENT_LESSON=""
    COMPLETED_STAGES=""
    PLAYER_NAME="catplayer"
    HINTS_USED=0
    COMMANDS_PRACTICED=""
    STAGE_1_COMPLETED=false
    # Which stage's world the sandbox currently holds; see prepare_stage_world.
    SANDBOX_STAGE=""
    # Completed work, as "stage<N>:<id>" entries. Keyed by stage so a reset of
    # one stage cannot mark another's lessons done.
    COMPLETED_LESSONS=""
    COMPLETED_MISSIONS=""
    # When this save was last written, in seconds since the epoch. The title
    # screen shows it, so a player with four profiles can tell which one they
    # were in the middle of.
    LAST_PLAYED=0
}

reset_progress_state
export CURRENT_STAGE CURRENT_SECTION CURRENT_LESSON COMPLETED_STAGES
export PLAYER_NAME HINTS_USED COMMANDS_PRACTICED STAGE_1_COMPLETED
export SANDBOX_STAGE COMPLETED_LESSONS COMPLETED_MISSIONS LAST_PLAYED

# ── Saving ─────────────────────────────────────────────────

# The bytes of the last save actually written, so a save that would change
# nothing can be skipped. Every command typed at the prompt calls through
# here, and rewriting the same file hundreds of times a session is only more
# chances to be interrupted in the middle of it.
PROGRESS_LAST_WRITTEN=""

# Everything the save holds except the timestamp, which is what the skip
# above compares: a save whose only difference is the clock is not a change.
progress_body() {
    cat <<EOF
PROGRESS_FORMAT="${PROGRESS_FORMAT_CURRENT}"
CURRENT_STAGE="${CURRENT_STAGE}"
CURRENT_SECTION="${CURRENT_SECTION}"
CURRENT_LESSON="${CURRENT_LESSON}"
COMPLETED_STAGES="${COMPLETED_STAGES}"
PLAYER_NAME="${PLAYER_NAME}"
HINTS_USED="${HINTS_USED}"
COMMANDS_PRACTICED="${COMMANDS_PRACTICED}"
STAGE_1_COMPLETED="${STAGE_1_COMPLETED}"
SANDBOX_STAGE="${SANDBOX_STAGE}"
COMPLETED_LESSONS="${COMPLETED_LESSONS}"
COMPLETED_MISSIONS="${COMPLETED_MISSIONS}"
EOF
}

# Write the save out, whole or not at all.
#
# The new contents go to a temporary file, are flushed to the disk, and are
# then moved over the real one. A rename is atomic, so whatever interrupts
# the game — the power going, the window closing, Ubuntu shutting down
# underneath it — the file on disk is either the whole previous save or the
# whole new one. Writing in place, as this used to, truncates the save first:
# a crash in that window left the player with an empty file and no game.
save_progress() {
    local body
    body="$(progress_body)"

    # The file has to still be there, too: a save someone deleted is a
    # change, even when the state in memory is what wrote it.
    if [[ "$body" == "$PROGRESS_LAST_WRITTEN" && -f "$PROGRESS_FILE" ]]; then
        return 0
    fi

    local dir tmp stamp
    stamp="$(current_epoch)"
    dir="$(dirname "$PROGRESS_FILE")"
    mkdir -p "$dir" 2>/dev/null || true
    tmp="${PROGRESS_FILE}.new.$$"

    if ! { printf '%s\n' "$body"
           printf 'LAST_PLAYED="%s"\n' "$stamp"; } > "$tmp" 2>/dev/null; then
        rm -f "$tmp" 2>/dev/null || true
        warn_save_failed
        return 0
    fi

    # Flushed before the rename, or a crash between the two can leave the
    # rename on disk pointing at a file whose contents never got there.
    sync "$tmp" 2>/dev/null || true

    if ! mv -f "$tmp" "$PROGRESS_FILE" 2>/dev/null; then
        rm -f "$tmp" 2>/dev/null || true
        warn_save_failed
        return 0
    fi
    sync "$dir" 2>/dev/null || true

    PROGRESS_LAST_WRITTEN="$body"
    LAST_PLAYED="$stamp"
    return 0
}

# A save that cannot be written is worth saying out loud — but not worth
# ending the game over, which is what a non-zero return would do under the
# errexit every one of these scripts runs with.
warn_save_failed() {
    printf 'catgame: could not write the save at %s\n' "$PROGRESS_FILE" >&2
}

current_epoch() {
    date +%s 2>/dev/null || printf '0'
}

# Autosave: called from the prompt after every command. save_progress is
# already a no-op when nothing has changed, so this costs a string compare
# until the moment there is something new to keep.
autosave_progress() {
    save_progress
}

# Write the save on the way out, however the way out comes about. Only the
# signals a process can still answer are covered here; nothing can be done
# about the plug being pulled, which is what the atomic write above is for.
#
# HUP is the terminal window being closed, TERM is Ubuntu shutting down or
# restarting, INT is Ctrl-C, and EXIT covers a clean quit and any error that
# trips errexit.
install_save_traps() {
    trap 'save_progress; exit 130' INT
    trap 'save_progress; exit 129' HUP
    trap 'save_progress; exit 143' TERM
    trap 'save_progress' EXIT
}

load_progress() {
    if [[ -f "$PROGRESS_FILE" ]]; then
        # A save from before the format was versioned leaves this at 0.
        PROGRESS_FORMAT=0
        # shellcheck disable=SC1090
        source "$PROGRESS_FILE"
        if [[ "${PROGRESS_FORMAT:-0}" != "$PROGRESS_FORMAT_CURRENT" ]]; then
            rebuild_learned_commands
            save_progress
        fi
    else
        save_progress
    fi
}

# ── Player profiles ────────────────────────────────────────

# A filename for a player name: lowercased, with anything that is not a letter
# or digit folded to a single underscore. Two spellings of the same name reach
# the same profile, which is what a returning player expects.
player_slug() {
    local slug
    slug="$(printf '%s' "${1:-}" \
        | tr '[:upper:]' '[:lower:]' \
        | tr -c 'a-z0-9' '_' \
        | sed -e 's/__*/_/g' -e 's/^_//' -e 's/_$//')"
    printf '%s' "${slug:-catplayer}"
}

# Where one player's typed commands are kept between sessions, beside their
# save, so switching profiles switches the history behind ↑ with it. The
# legacy single-save path is not a ".progress" file, so it is named here
# rather than derived — deriving it would have written the history over the
# save itself.
player_history_file() {
    if [[ "$PROGRESS_FILE" == *.progress ]]; then
        printf '%s' "${PROGRESS_FILE%.progress}.history"
    else
        printf '%s' "${PROGRESS_DIR}/catplayer.history"
    fi
}

# What is safe to keep as a player's name. The save is a shell file that
# load_progress sources, so a name carrying a quote, a backslash or a $( )
# would either break the next load or be run as code by it. Control
# characters go too — a name with a newline in it becomes two save lines.
sanitize_player_name() {
    local name="$1"

    name="${name//[\"\\\`\$]/}"
    name="$(printf '%s' "$name" | tr -d '[:cntrl:]')"
    name="${name#"${name%%[![:space:]]*}"}"
    name="${name%"${name##*[![:space:]]}"}"
    printf '%s' "${name:0:32}"
}

# Point the save file at one player's own profile and load it. Returns 0 if
# that player has played before (so the caller can welcome them back), 1 if
# this is a new profile.
select_player_profile() {
    local name
    name="$(sanitize_player_name "${1:-catplayer}")"
    [[ -n "$name" ]] || name="catplayer"
    local slug
    slug="$(player_slug "$name")"

    # The skip-if-unchanged cache belongs to whichever file was being
    # written; the next save is to a different one.
    PROGRESS_LAST_WRITTEN=""

    mkdir -p "$PROGRESS_DIR"
    PROGRESS_FILE="${PROGRESS_DIR}/${slug}.progress"

    # Older versions kept a single save in the game directory. Hand it to the
    # player whose name is in it, once, so nobody loses progress to the
    # upgrade — and so nobody else inherits it.
    if [[ ! -f "$PROGRESS_FILE" && -f "$LEGACY_PROGRESS_FILE" ]]; then
        local legacy_name
        legacy_name="$(sed -n 's/^PLAYER_NAME="\(.*\)"$/\1/p' "$LEGACY_PROGRESS_FILE" | head -1)"
        if [[ "$(player_slug "$legacy_name")" == "$slug" ]]; then
            mv "$LEGACY_PROGRESS_FILE" "$PROGRESS_FILE"
        fi
    fi

    local returning=1
    if [[ -f "$PROGRESS_FILE" ]]; then
        returning=0
    fi

    reset_progress_state
    load_progress
    # The name just typed wins over the one on disk: same profile, but the
    # player may have spelled it differently this time.
    PLAYER_NAME="$name"
    printf '%s\n' "$slug" > "${PROGRESS_DIR}/last_player"
    save_progress

    return "$returning"
}

# For tools outside the game loop (check.sh), which have nobody to ask.
select_last_player_profile() {
    local pointer="${PROGRESS_DIR}/last_player" slug=""

    if [[ -f "$pointer" ]]; then
        slug="$(head -1 "$pointer")"
    fi
    if [[ -n "$slug" && -f "${PROGRESS_DIR}/${slug}.progress" ]]; then
        PROGRESS_FILE="${PROGRESS_DIR}/${slug}.progress"
    fi
    load_progress
}

# One field out of a save, read rather than sourced. Sourcing another
# player's file to find out their name would drop their stage, their lessons
# and their hint count into the session that is running.
progress_field() {
    local file="$1" field="$2"
    [[ -f "$file" ]] || return 1
    sed -n "s/^${field}=\"\(.*\)\"\$/\1/p" "$file" | head -1
}

# The names that already have a save, most recently played first, so the
# title screen opens on the game somebody is in the middle of.
list_player_profiles() {
    local file name played

    [[ -d "$PROGRESS_DIR" ]] || return 0
    for file in "$PROGRESS_DIR"/*.progress; do
        [[ -f "$file" ]] || continue
        name="$(progress_field "$file" PLAYER_NAME)"
        [[ -n "$name" ]] || continue
        played="$(progress_field "$file" LAST_PLAYED)"
        [[ "$played" =~ ^[0-9]+$ ]] || played=0
        printf '%s\t%s\n' "$played" "$name"
    done | sort -k1,1nr -s | cut -f2-
    return 0
}

# ── Player profiles: create, rename, delete ────────────────
#
# The title screen used to be a list of names and a prompt to type one. A
# name typed differently was a whole new player, a profile could not be
# renamed, and the only way to remove one was to know where the game keeps
# its saves. These are the operations behind that screen; players.sh is the
# screen itself.

player_profile_path() {
    printf '%s' "${PROGRESS_DIR}/$(player_slug "$1").progress"
}

player_profile_history_path() {
    printf '%s' "${PROGRESS_DIR}/$(player_slug "$1").history"
}

player_profile_exists() {
    [[ -f "$(player_profile_path "$1")" ]]
}

# Create. Returns 1 if that name is taken — the caller says so rather than
# dropping the new player into somebody else's game, which is what happens
# when two names fold to the same profile.
create_player_profile() {
    local name
    name="$(sanitize_player_name "${1:-}")"

    [[ -n "$name" ]] || return 2
    ! player_profile_exists "$name" || return 1

    select_player_profile "$name" || true
    return 0
}

# Rename. The save keeps the player's name inside it as well as in its
# filename, and the history file is named after the same slug, so all three
# have to move together.
#   1  the new name already belongs to another profile
#   2  the new name is empty once it has been made safe to store
#   3  there is no profile under the old name
rename_player_profile() {
    local old="$1" new
    new="$(sanitize_player_name "${2:-}")"

    [[ -n "$new" ]] || return 2
    player_profile_exists "$old" || return 3

    local old_slug new_slug old_file new_file
    old_slug="$(player_slug "$old")"
    new_slug="$(player_slug "$new")"
    old_file="${PROGRESS_DIR}/${old_slug}.progress"
    new_file="${PROGRESS_DIR}/${new_slug}.progress"

    if [[ "$old_slug" != "$new_slug" ]]; then
        [[ ! -f "$new_file" ]] || return 1
        mv -f "$old_file" "$new_file" || return 1
        if [[ -f "${PROGRESS_DIR}/${old_slug}.history" ]]; then
            mv -f "${PROGRESS_DIR}/${old_slug}.history" \
                  "${PROGRESS_DIR}/${new_slug}.history" || true
        fi
    fi

    rewrite_progress_field "$new_file" PLAYER_NAME "$new" || return 1

    # The pointer is how check.sh finds a player with nobody there to ask.
    if [[ "$(read_last_player)" == "$old_slug" ]]; then
        printf '%s\n' "$new_slug" > "${PROGRESS_DIR}/last_player"
    fi

    # Renaming whoever is playing right now moves the live session with them.
    if [[ "$PROGRESS_FILE" == "$old_file" ]]; then
        PROGRESS_FILE="$new_file"
        PLAYER_NAME="$new"
        PROGRESS_LAST_WRITTEN=""
    fi
    return 0
}

# Delete. The save and the command history go together — leaving the history
# behind would hand the next player with that name somebody else's commands.
delete_player_profile() {
    local name="$1" slug
    slug="$(player_slug "$name")"

    player_profile_exists "$name" || return 1

    rm -f "${PROGRESS_DIR}/${slug}.progress" \
          "${PROGRESS_DIR}/${slug}.history" 2>/dev/null || return 1

    if [[ "$(read_last_player)" == "$slug" ]]; then
        rm -f "${PROGRESS_DIR}/last_player" 2>/dev/null || true
    fi
    return 0
}

read_last_player() {
    local pointer="${PROGRESS_DIR}/last_player"
    [[ -f "$pointer" ]] || return 0
    head -1 "$pointer"
}

# Change one line of a save in place, atomically, without sourcing it. Done
# in the shell rather than with sed because a player's name is free text and
# a slash or an ampersand in it would be a sed replacement of its own.
rewrite_progress_field() {
    local file="$1" field="$2" value="$3"
    local tmp="${file}.new.$$" line found=false

    [[ -f "$file" ]] || return 1
    {
        while IFS= read -r line; do
            if [[ "$line" == "${field}="* ]]; then
                printf '%s="%s"\n' "$field" "$value"
                found=true
            else
                printf '%s\n' "$line"
            fi
        done < "$file"
        [[ "$found" == true ]] || printf '%s="%s"\n' "$field" "$value"
    } > "$tmp" 2>/dev/null || { rm -f "$tmp"; return 1; }

    sync "$tmp" 2>/dev/null || true
    mv -f "$tmp" "$file" 2>/dev/null || { rm -f "$tmp"; return 1; }
    return 0
}

# What the title screen shows under a name: how far they got, and when they
# were last here.
player_profile_summary() {
    local file stage lessons played count=0 entry
    file="$(player_profile_path "$1")"
    [[ -f "$file" ]] || return 1

    stage="$(progress_field "$file" CURRENT_STAGE)"
    lessons="$(progress_field "$file" COMPLETED_LESSONS)"
    played="$(progress_field "$file" LAST_PLAYED)"

    for entry in $lessons; do count=$((count + 1)); done

    printf 'Stage %s · %s lesson%s · %s' \
        "${stage:-1}" "$count" "$([[ "$count" == 1 ]] || printf 's')" \
        "$(time_ago "${played:-0}")"
}

# "3 days ago", for a timestamp that may be missing, zero or from a save an
# older version wrote without one.
time_ago() {
    local then="${1:-0}" now diff
    [[ "$then" =~ ^[0-9]+$ ]] || then=0
    if [[ "$then" -eq 0 ]]; then
        printf 'not played yet'
        return 0
    fi

    now="$(current_epoch)"
    diff=$((now - then))
    ((diff < 0)) && diff=0

    if ((diff < 60)); then
        printf 'just now'
    elif ((diff < 3600)); then
        printf '%s minutes ago' "$((diff / 60))"
    elif ((diff < 86400)); then
        printf '%s hours ago' "$((diff / 3600))"
    elif ((diff < 172800)); then
        printf 'yesterday'
    else
        printf '%s days ago' "$((diff / 86400))"
    fi
}

# ── Completion tracking ────────────────────────────────────

mark_lesson_complete() {
    local lesson_id="$1"
    local key="stage${CURRENT_STAGE}:${lesson_id}"

    CURRENT_LESSON="$lesson_id"
    if [[ " $COMPLETED_LESSONS " != *" $key "* ]]; then
        COMPLETED_LESSONS="${COMPLETED_LESSONS} $key"
        COMPLETED_LESSONS="${COMPLETED_LESSONS# }"
    fi
    save_progress
}

lesson_is_complete() {
    [[ " $COMPLETED_LESSONS " == *" stage${CURRENT_STAGE}:${1} "* ]]
}

mark_mission_complete() {
    local mission_id="$1"
    local key="stage${CURRENT_STAGE}:${mission_id}"

    if [[ " $COMPLETED_MISSIONS " != *" $key "* ]]; then
        COMPLETED_MISSIONS="${COMPLETED_MISSIONS} $key"
        COMPLETED_MISSIONS="${COMPLETED_MISSIONS# }"
    fi
    save_progress
}

mission_is_complete() {
    [[ " $COMPLETED_MISSIONS " == *" stage${CURRENT_STAGE}:${1} "* ]]
}

mark_section_complete() {
    local section="$1"
    CURRENT_SECTION="$section"
    save_progress
}

stage_is_complete() {
    [[ " $COMPLETED_STAGES " == *" ${1} "* ]]
}

# Forget everything recorded for one stage, so it runs from its first lesson
# again. Used when jumping back into a stage that is already finished — with
# its lessons still marked done, run_stage would skip straight past it.
clear_stage_progress() {
    local stage_num="$1"
    local kept="" entry

    for entry in $COMPLETED_LESSONS; do
        [[ "$entry" == "stage${stage_num}:"* ]] || kept="${kept} ${entry}"
    done
    COMPLETED_LESSONS="${kept# }"

    kept=""
    for entry in $COMPLETED_MISSIONS; do
        [[ "$entry" == "stage${stage_num}:"* ]] || kept="${kept} ${entry}"
    done
    COMPLETED_MISSIONS="${kept# }"

    kept=""
    for entry in $COMPLETED_STAGES; do
        [[ "$entry" == "$stage_num" ]] || kept="${kept} ${entry}"
    done
    COMPLETED_STAGES="${kept# }"

    if [[ "$stage_num" == "1" ]]; then
        STAGE_1_COMPLETED=false
    fi

    # The list is rebuilt from what is still finished, so a replayed stage
    # does not keep claiming commands the player has yet to re-learn.
    rebuild_learned_commands
    save_progress
}

mark_stage_complete() {
    local stage_num="$1"
    if [[ " $COMPLETED_STAGES " != *" $stage_num "* ]]; then
        COMPLETED_STAGES="${COMPLETED_STAGES} $stage_num"
        COMPLETED_STAGES="${COMPLETED_STAGES# }" # trim leading space
    fi
    if [[ "$stage_num" == "1" ]]; then
        STAGE_1_COMPLETED=true
    fi
    CURRENT_STAGE=$((stage_num + 1))
    save_progress
}

# ── Learned commands ───────────────────────────────────────

# Only the curriculum belongs in this list: it is what `help` shows as the
# commands you have learned. Matching is a glob, not a regex, because the
# entries include things like ">", "&", "$1" and "sort | uniq -c".
add_learned_command() {
    local cmd="$1"

    [[ -n "$cmd" ]] || return 0
    if [[ " $COMMANDS_PRACTICED " != *" $cmd "* ]]; then
        COMMANDS_PRACTICED="${COMMANDS_PRACTICED} $cmd"
        COMMANDS_PRACTICED="${COMMANDS_PRACTICED# }"
        save_progress
    fi
}

get_learned_commands() {
    echo "$COMMANDS_PRACTICED"
}

# The command one lesson teaches. Only the assignment line is evaluated, so
# reading a lesson here cannot run its setup or its checks.
lesson_taught_command() {
    local line
    line="$(grep -m1 '^LESSON_COMMAND=' "$1" 2>/dev/null)" || return 1
    ( eval "$line" 2>/dev/null; printf '%s' "${LESSON_COMMAND:-}" )
}

# Earlier versions recorded whatever the player typed at the prompt, so old
# saves list typos and shell noise ("vsquit", "hi", "bash") beside the real
# lessons. Rebuild the list from the lessons actually completed.
rebuild_learned_commands() {
    local rebuilt="" key stage lesson file cmd

    for key in $COMPLETED_LESSONS; do
        stage="${key%%:*}"
        lesson="${key#*:}"
        [[ "$stage" == stage* && -n "$lesson" && "$lesson" != "$key" ]] || continue

        file="${GAME_ROOT:-.}/stages/${stage}/lessons/${lesson}.sh"
        [[ -f "$file" ]] || continue

        cmd="$(lesson_taught_command "$file")" || continue
        [[ -n "$cmd" ]] || continue
        if [[ " $rebuilt " == *" $cmd "* ]]; then
            continue
        fi
        rebuilt="${rebuilt} ${cmd}"
    done

    COMMANDS_PRACTICED="${rebuilt# }"
}

increment_hints_used() {
    HINTS_USED=$((HINTS_USED + 1))
    save_progress
}
