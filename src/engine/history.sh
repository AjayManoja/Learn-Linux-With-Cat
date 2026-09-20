#!/usr/bin/env bash
# history.sh — line editing and command recall at the game prompt.
#
# The prompt used to read a bare line, which meant no line editor was
# attached to it: pressing ↑ sent the escape sequence \e[A and that landed
# in the command as a literal "^[[A", and ← only moved the cursor over
# characters the shell would never let you change. Handing the line to
# readline instead (read -e) is what makes ↑/↓, ←/→, Home/End and the usual
# Ctrl- editing keys work, and ↑/↓ then walk the history list kept here.
#
# Sourced after progress.sh: the history file lives beside the player's save.

# How many commands are kept on disk between sessions.
HISTORY_LIMIT=500
# The player's own history file; set by init_command_history.
HISTORY_FILE=""
# The last command stored, so holding down a command does not fill the
# history with copies of it.
HISTORY_LAST=""

# Readline needs a terminal at both ends. Piped sessions — the test suite,
# `echo pwd | ./start.sh` — fall back to the plain read, which behaves
# exactly as it did before. CATGAME_NO_READLINE=1 forces that path.
prompt_can_edit() {
    [[ -z "${CATGAME_NO_READLINE:-}" ]] && [[ -t 0 ]] && [[ -t 1 ]]
}

# A colour escape inside a prompt. Readline counts every character of the
# prompt as a column it printed, so an unfenced escape makes it think the
# prompt is ~10 columns wider than it looks; recalling a long command with ↑
# then wraps in the wrong place and smears the line. \001…\002 is how a
# prompt tells readline "this part prints nothing" (it is what \[ \] in PS1
# turns into). The plain read has no such notion, so it gets the escape bare.
prompt_color() {
    local color="$1"
    [[ -n "$color" ]] || return 0
    if prompt_can_edit; then
        printf '\001%b\002' "$color"
    else
        printf '%b' "$color"
    fi
}

# Load this player's history into the shell's history list, so their last
# session's commands are already behind ↑ when they sit down again.
init_command_history() {
    HISTORY_LAST=""
    HISTORY_FILE="$(player_history_file)"

    # Start from an empty list: without this the list holds whatever the
    # engine itself ran, and ↑ offers the player the game's own internals.
    history -c 2>/dev/null || return 0

    [[ -f "$HISTORY_FILE" ]] || return 0

    local lines
    lines="$(wc -l < "$HISTORY_FILE" 2>/dev/null || echo 0)"
    if [[ "$lines" -gt "$HISTORY_LIMIT" ]]; then
        local trimmed="${HISTORY_FILE}.tmp"
        if tail -n "$HISTORY_LIMIT" "$HISTORY_FILE" > "$trimmed" 2>/dev/null; then
            mv "$trimmed" "$HISTORY_FILE"
        else
            rm -f "$trimmed"
        fi
    fi

    history -r "$HISTORY_FILE" 2>/dev/null || true
    HISTORY_LAST="$(tail -n 1 "$HISTORY_FILE" 2>/dev/null || true)"
}

# Put one typed command behind ↑, for this session and the next.
remember_command() {
    local cmd="$1"

    [[ -n "$cmd" ]] || return 0
    # Only consecutive repeats are dropped; a command typed again later is
    # worth having in its own right, next to where it was typed.
    [[ "$cmd" == "$HISTORY_LAST" ]] && return 0
    HISTORY_LAST="$cmd"

    # -- or a command starting with a dash is read as an option to history.
    history -s -- "$cmd" 2>/dev/null || true

    [[ -n "$HISTORY_FILE" ]] || return 0
    mkdir -p "$(dirname "$HISTORY_FILE")" 2>/dev/null || return 0
    printf '%s\n' "$cmd" >> "$HISTORY_FILE" 2>/dev/null || true
}

# Read one line into the named variable, with the editing keys live.
#   read_line <prompt> <variable name> [timeout seconds]
# Returns what read returns, so a timeout or end of input is still the
# caller's to handle.
read_line() {
    local _rl_prompt="$1" _rl_var="$2" _rl_timeout="${3:-}"

    if prompt_can_edit; then
        if [[ -n "$_rl_timeout" ]]; then
            read -e -r -t "$_rl_timeout" -p "$_rl_prompt" "$_rl_var"
        else
            read -e -r -p "$_rl_prompt" "$_rl_var"
        fi
    else
        # read -p writes to stderr; the prompt has always gone to stdout
        # here, and the tests read stdout.
        printf '%s' "$_rl_prompt"
        if [[ -n "$_rl_timeout" ]]; then
            read -r -t "$_rl_timeout" "$_rl_var"
        else
            read -r "$_rl_var"
        fi
    fi
}

# Readline's own settings, kept in the game's directory.
#
# Two reasons for a private inputrc. Tab completion is readline's default
# binding, and it would complete against the directory the game was launched
# from — the repository's own files, which are not in the game world and
# which the sandbox otherwise never shows. And a player whose ~/.inputrc
# selects vi editing would find the arrow keys behaving unlike the rest of
# the lesson they are in the middle of.
init_line_editing() {
    prompt_can_edit || return 0

    local rc="${PROGRESS_DIR}/inputrc"
    mkdir -p "$PROGRESS_DIR" 2>/dev/null || return 0
    cat > "$rc" <<'RC' 2>/dev/null || return 0
# Written by Learn Linux with Cat. Edit the game, not this file: it is
# rewritten on every run.
set editing-mode emacs
set disable-completion on
RC
    export INPUTRC="$rc"
}
