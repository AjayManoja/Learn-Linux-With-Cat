#!/usr/bin/env bash
set -euo pipefail

# Bump this when a save written by an older version needs repairing on load.
PROGRESS_FORMAT_CURRENT=2

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
}

reset_progress_state
export CURRENT_STAGE CURRENT_SECTION CURRENT_LESSON COMPLETED_STAGES
export PLAYER_NAME HINTS_USED COMMANDS_PRACTICED STAGE_1_COMPLETED
export SANDBOX_STAGE COMPLETED_LESSONS COMPLETED_MISSIONS

save_progress() {
    mkdir -p "$(dirname "$PROGRESS_FILE")"
    cat > "$PROGRESS_FILE" <<EOF
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

# Point the save file at one player's own profile and load it. Returns 0 if
# that player has played before (so the caller can welcome them back), 1 if
# this is a new profile.
select_player_profile() {
    local name="${1:-catplayer}"
    local slug
    slug="$(player_slug "$name")"

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

# The names that already have a save, for the title screen.
list_player_profiles() {
    local file name

    [[ -d "$PROGRESS_DIR" ]] || return 0
    for file in "$PROGRESS_DIR"/*.progress; do
        [[ -f "$file" ]] || continue
        name="$(sed -n 's/^PLAYER_NAME="\(.*\)"$/\1/p' "$file" | head -1)"
        [[ -n "$name" ]] && printf '%s\n' "$name"
    done
    return 0
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
