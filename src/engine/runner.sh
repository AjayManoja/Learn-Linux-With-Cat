#!/usr/bin/env bash
# runner.sh — Stage runner / main game loop
# This file is sourced by start.sh (which already sources all other modules).
# Do NOT source other modules here to avoid double-sourcing.

# Game state — initialized by start.sh or load_progress
CURRENT_GAME_DIR="${CURRENT_GAME_DIR:-}"

# ── Stage Loading ──────────────────────────────────────────

load_stage() {
    local stage_num="$1"
    local conf_file="${GAME_ROOT}/stages/stage${stage_num}/stage.conf"

    if [[ -f "$conf_file" ]]; then
        source "$conf_file"
        export CURRENT_STAGE="$stage_num"
        unlock_commands "${STAGE_COMMANDS:-}"
    else
        echo "Error: Stage $stage_num config not found at $conf_file"
        exit 1
    fi
}

# ── Command Gating ─────────────────────────────────────────
# The game only runs commands the player has been taught. Each stage.conf
# declares STAGE_COMMANDS; load_stage unlocks them as the stage begins.

ALLOWED_COMMANDS="${ALLOWED_COMMANDS:-}"

unlock_commands() {
    local c
    for c in $1; do
        if [[ " $ALLOWED_COMMANDS " != *" $c "* ]]; then
            ALLOWED_COMMANDS="${ALLOWED_COMMANDS} $c"
        fi
    done
    ALLOWED_COMMANDS="${ALLOWED_COMMANDS# }"
}

command_unlocked() {
    [[ " $ALLOWED_COMMANDS " == *" $1 "* ]]
}

# A player resuming at stage 3 never ran stages 1 and 2, so their commands
# have to be unlocked up front or half the vocabulary disappears.
unlock_prior_commands() {
    local upto="$1" s conf line
    for (( s = 1; s < upto; s++ )); do
        conf="${GAME_ROOT}/stages/stage${s}/stage.conf"
        [[ -f "$conf" ]] || continue
        line=$(grep -E '^STAGE_COMMANDS=' "$conf" | head -1) || true
        [[ -n "$line" ]] || continue
        line="${line#STAGE_COMMANDS=}"
        line="${line//\"/}"
        unlock_commands "$line"
    done
}

# ── Sandbox Command Execution ─────────────────────────────

# Shell syntax the sandbox refuses outright. Pipes, redirection and background
# jobs are the point of later stages, but chaining and command substitution are
# escape hatches around the command allowlist.
# Quoting decides whether a metacharacter is an escape hatch or just text.
# Stage 5 has the player write shell code into files:
#   echo 'if [ -f data.txt ]; then' >> check.sh
# That semicolon is inside quotes and chains nothing, so only unquoted
# occurrences are refused.
sandbox_syntax_ok() {
    local line="$1"
    local i ch quote="" prev=""

    for (( i = 0; i < ${#line}; i++ )); do
        ch="${line:i:1}"

        if [[ -n "$quote" ]]; then
            [[ "$ch" == "$quote" ]] && quote=""
            prev="$ch"
            continue
        fi

        case "$ch" in
            "'"|'"') quote="$ch" ;;
            ';'|'`')  return 1 ;;
            '&') [[ "$prev" == '&' ]] && return 1 ;;   # && chains; a lone & backgrounds
            '|') [[ "$prev" == '|' ]] && return 1 ;;   # || chains; a lone | pipes
            '(') [[ "$prev" == '$' || "$prev" == '>' || "$prev" == '<' ]] && return 1 ;;
        esac

        prev="$ch"
    done

    return 0
}

# Splits on unquoted pipes only, one segment per line.
split_unquoted_pipes() {
    local line="$1"
    local i ch quote="" segment=""

    for (( i = 0; i < ${#line}; i++ )); do
        ch="${line:i:1}"

        if [[ -n "$quote" ]]; then
            [[ "$ch" == "$quote" ]] && quote=""
            segment+="$ch"
            continue
        fi

        case "$ch" in
            "'"|'"') quote="$ch"; segment+="$ch" ;;
            '|') printf '%s
' "$segment"; segment="" ;;
            *) segment+="$ch" ;;
        esac
    done

    printf '%s
' "$segment"
}

# Rewrite the path the player sees onto the real sandbox directory.
map_virtual_paths() {
    local line="$1"
    echo "${line//\/home\/catplayer/$SANDBOX_HOME}"
}

# Every path argument must land inside the sandbox.
sandbox_paths_ok() {
    local line="$1" tok resolved
    for tok in $line; do
        case "$tok" in
            -*|'|'|'>'|'>>'|'<'|'&') continue ;;
            "$SANDBOX_HOME"*) continue ;;
            /*) return 1 ;;
            *..*)
                resolved=$(cd "$CURRENT_GAME_DIR" 2>/dev/null && realpath -m "$tok" 2>/dev/null) || return 1
                [[ "$resolved" == "$SANDBOX_HOME"* ]] || return 1
                ;;
        esac
    done
    return 0
}

# Each stage of a pipeline has to start with a command the player has learned.
pipeline_commands_ok() {
    local line="$1" segment first
    while IFS= read -r segment; do
        first=$(echo "$segment" | awk '{print $1}')
        [[ -n "$first" ]] || continue
        # A variable assignment prefix ('NAME=value cmd') is not a command.
        [[ "$first" == *=* ]] && continue
        if ! command_unlocked "$first"; then
            UNKNOWN_COMMAND="$first"
            return 1
        fi
    done < <(split_unquoted_pipes "$line")
    return 0
}

# ── Background Jobs ────────────────────────────────────────
# Stage 4 teaches 'kill', which means the player types a PID. Only processes
# this game started may be targeted: a bare `kill 1234` would otherwise reach
# anything their account owns, including their own editor or shell.

game_pid_file() {
    echo "${SANDBOX_ROOT}/.game_pids"
}

record_game_pid() {
    echo "$1" >> "$(game_pid_file)"
}

# True only for a PID this game launched and that is still alive.
pid_is_ours() {
    local pid="$1" file
    [[ "$pid" =~ ^[0-9]+$ ]] || return 1
    file="$(game_pid_file)"
    [[ -f "$file" ]] || return 1
    grep -qx "$pid" "$file"
}

list_game_pids() {
    local file pid
    file="$(game_pid_file)"
    [[ -f "$file" ]] || return 0
    while read -r pid; do
        [[ -n "$pid" ]] || continue
        kill -0 "$pid" 2>/dev/null && echo "$pid"
    done < "$file"
}

execute_in_sandbox() {
    local cmd_line="$1"
    local cmd args

    cmd=$(echo "$cmd_line" | awk '{print $1}')
    args=$(echo "$cmd_line" | cut -d' ' -f2- -s)

    cd "$CURRENT_GAME_DIR" 2>/dev/null || true

    # cd and pwd are not real commands here: the game keeps its own working
    # directory so the player sees /home/catplayer instead of the sandbox path.
    case "$cmd" in
        cd)
            local target_dir="$args"

            if [[ -z "$target_dir" || "$target_dir" == "~" ]]; then
                CURRENT_GAME_DIR="$SANDBOX_HOME"
                return 0
            fi

            local new_dir
            if [[ "$target_dir" == /* ]]; then
                new_dir=$(echo "$target_dir" | sed "s|^/home/catplayer|$SANDBOX_HOME|")
            else
                new_dir=$(cd "$CURRENT_GAME_DIR" && realpath -m "$target_dir" 2>/dev/null)
            fi

            if [[ "$new_dir" != "$SANDBOX_HOME"* ]]; then
                show_cat "warning" "Hey! You can't leave our game world!"
                return 1
            fi

            if [[ -d "$new_dir" ]]; then
                CURRENT_GAME_DIR="$new_dir"
            else
                echo "bash: cd: ${target_dir}: No such file or directory"
            fi
            return 0
            ;;

        pwd)
            local rel_path
            rel_path=$(realpath --relative-to="$SANDBOX_HOME" "$CURRENT_GAME_DIR" 2>/dev/null || echo ".")
            if [[ "$rel_path" == "." ]]; then
                echo "/home/catplayer"
            else
                echo "/home/catplayer/$rel_path"
            fi
            return 0
            ;;

        rm)
            # Stage 1 promises deleted files are recoverable, so rm on its own
            # goes through the trash bin rather than the real thing.
            if [[ "$cmd_line" != *'|'* && "$cmd_line" != *'>'* ]]; then
                local target="$args"
                target="${target//-r /}"
                target="${target//-f /}"
                target="${target//-rf /}"
                target="${target//-fr /}"
                if [[ -z "$target" ]]; then
                    echo "rm: missing operand"
                    return 0
                fi
                local target_path="${CURRENT_GAME_DIR}/${target}"
                if [[ "$target_path" == "$SANDBOX_HOME"* ]]; then
                    safe_rm "$target_path"
                else
                    show_cat "warning" "You can't delete things outside our game world!"
                fi
                return 0
            fi
            ;;
    esac

    # Everything else runs for real, inside the sandbox, once it clears the
    # gates. Running the genuine tools is the whole point: the player should be
    # learning grep and sort, not an imitation of them.
    if ! sandbox_syntax_ok "$cmd_line"; then
        show_cat "warning" "Let's keep it to one command at a time — no ';', '&&' or backticks yet."
        return 0
    fi

    local mapped
    mapped=$(map_virtual_paths "$cmd_line")

    if ! sandbox_paths_ok "$mapped"; then
        show_cat "warning" "That path is outside our game world!"
        return 0
    fi

    UNKNOWN_COMMAND=""
    if ! pipeline_commands_ok "$mapped"; then
        show_cat "confused" "I don't know '${UNKNOWN_COMMAND}' yet. Try 'help' to see what you've learned!"
        return 0
    fi

    # `kill` is gated to this game's own background jobs.
    if [[ "$cmd" == "kill" ]]; then
        local tok found_pid=false
        for tok in $args; do
            [[ "$tok" =~ ^-  ]] && continue
            found_pid=true
            if ! pid_is_ours "$tok"; then
                show_cat "warning" "PID ${tok} isn't one of ours — I only let you stop jobs this game started."
                return 0
            fi
        done
        if [[ "$found_pid" == false ]]; then
            echo "kill: usage: kill <pid>"
            return 0
        fi
    fi

    # A trailing '&' runs the command in the background. It is launched from
    # here rather than inside a throwaway subshell so its PID can be recorded
    # and, later, verified by the kill gate above.
    if [[ "$mapped" =~ \&[[:space:]]*$ ]]; then
        local bg_cmd="${mapped%&}"
        ( cd "$CURRENT_GAME_DIR" && eval "$bg_cmd" ) >/dev/null 2>&1 &
        local bg_pid=$!
        record_game_pid "$bg_pid"
        echo "[background] started with PID ${bg_pid}"
        return 0
    fi

    ( cd "$CURRENT_GAME_DIR" && eval "$mapped" ) 2>&1 || true
    return 0
}

# ── Interactive Prompt ─────────────────────────────────────

interactive_prompt() {
    local task_complete=false
    # Track last command for the checker
    LAST_COMMAND=""

    while ! $task_complete; do
        # Build the prompt showing virtual path
        local display_dir
        display_dir=$(realpath --relative-to="$SANDBOX_HOME" "$CURRENT_GAME_DIR" 2>/dev/null || echo ".")
        if [[ "$display_dir" == "." ]]; then
            display_dir="~"
        else
            display_dir="~/${display_dir}"
        fi

        echo -ne "${GREEN}${PLAYER_NAME:-catplayer}@linux${RESET}:${BLUE}${display_dir}${RESET}\$ "

        local input=""
        if read -t 60 -r input; then
            # Trim surrounding whitespace. This used to go through xargs,
            # which also strips quotes and re-splits words: typing
            #   echo '#!/usr/bin/env bash' > script.sh
            # arrived as an unquoted '#!...' and the shell read the rest of
            # the line as a comment, so the command silently did nothing.
            input="${input#"${input%%[![:space:]]*}"}"
            input="${input%"${input##*[![:space:]]}"}"

            if [[ -z "$input" ]]; then
                continue
            fi

            LAST_COMMAND="$input"

            case "$input" in
                hint)
                    give_hint
                    ;;
                quit|exit)
                    save_progress
                    show_cat "sad" "Progress saved. See you next time! 🐾"
                    exit 0
                    ;;
                help)
                    echo ""
                    echo "Commands you've learned: $(get_learned_commands)"
                    echo "Game commands: hint, help, progress, quit"
                    echo ""
                    ;;
                progress)
                    echo ""
                    echo "📊 Stage ${CURRENT_STAGE}: ${STAGE_NAME:-}"
                    echo "   Section: ${CURRENT_SECTION:-?}"
                    echo "   Hints used: ${HINTS_USED:-0}"
                    echo ""
                    ;;
                *)
                    # Safety check
                    if ! check_safety "$input"; then
                        show_cat "warning" "That command is blocked in the sandbox! Try something else."
                        continue
                    fi

                    # Execute the command in sandbox
                    execute_in_sandbox "$input" || true

                    # Track the base command as learned
                    local base_cmd
                    base_cmd=$(echo "$input" | awk '{print $1}')
                    add_learned_command "$base_cmd"

                    # Check if the current task is complete
                    if type check_task &>/dev/null; then
                        if check_task; then
                            task_complete=true
                            # Missions clear this and announce their own
                            # message once the prompt returns.
                            if [[ -n "${TASK_SUCCESS_MSG:-}" ]]; then
                                echo ""
                                show_cat "${TASK_SUCCESS_POSE:-happy}" "$TASK_SUCCESS_MSG"
                                echo ""
                            fi
                        fi
                    fi
                    ;;
            esac
        else
            # 60-second timeout — player is idle
            echo ""
            show_cat "sleeping" "Zzz... Are you still there? Type a command!"
            echo ""
        fi
    done
}

# ── Lesson Runner ──────────────────────────────────────────

run_lesson() {
    local lesson_id="$1"
    local lesson_script="${GAME_ROOT}/stages/stage${CURRENT_STAGE}/lessons/${lesson_id}.sh"

    if [[ ! -f "$lesson_script" ]]; then
        echo "Error: Lesson script not found: $lesson_script"
        return 1
    fi

    # Reset state for this lesson
    reset_hint_level
    unset -f check_task 2>/dev/null || true
    unset -f setup_lesson 2>/dev/null || true

    # Source the lesson (defines variables + check_task function)
    source "$lesson_script"

    # Set hints from lesson variables
    set_hints "${HINT_1:-}" "${HINT_2:-}" "${HINT_3:-}"

    # Show the teaching moment
    echo ""
    show_cat "${LESSON_CAT_POSE:-default}"
    show_lesson_box "${LESSON_TITLE:-CAT SAYS}" "${LESSON_CONTENT:-}"
    echo ""

    # Pause for reading
    read -r -p "Press Enter when you're ready to try it... "
    echo ""

    # Show the task
    show_cat "${TASK_CAT_POSE:-thinking}"
    show_task_box "${TASK_INSTRUCTION:-Try the command!}"
    echo ""

    # Enter interactive mode until task is complete
    interactive_prompt

    # Mark lesson done
    mark_lesson_complete "$lesson_id"
    add_learned_command "${LESSON_COMMAND:-}"

    # Brief pause before next lesson
    echo ""
    read -r -p "Press Enter to continue... "
    echo ""
}

# ── Mission Runner ─────────────────────────────────────────

run_mission() {
    local mission_id="$1"
    local mission_script="${GAME_ROOT}/stages/stage${CURRENT_STAGE}/missions/${mission_id}.sh"

    if [[ ! -f "$mission_script" ]]; then
        echo "Error: Mission script not found: $mission_script"
        return 1
    fi

    # Reset state
    reset_hint_level
    unset -f check_task 2>/dev/null || true
    unset -f check_mission 2>/dev/null || true
    unset -f setup_mission 2>/dev/null || true

    # Source the mission
    source "$mission_script"

    # Set hints
    set_hints "${HINT_1:-}" "${HINT_2:-}" "${HINT_3:-}"

    # Run mission setup (creates maze, places files, etc.)
    if type setup_mission &>/dev/null; then
        setup_mission
    fi

    # Show mission briefing
    echo ""
    show_cat "${MISSION_CAT_POSE:-mission}"
    show_mission_box "${MISSION_TITLE:-Mission}" "${MISSION_BRIEFING:-Complete the mission!}"
    echo ""

    # Re-alias check_mission as check_task so interactive_prompt can use it
    if type check_mission &>/dev/null; then
        check_task() { check_mission; }
    fi

    # Otherwise the last lesson's success line fires when the mission passes,
    # just before the mission announces its own.
    TASK_SUCCESS_MSG=""
    TASK_SUCCESS_POSE=""

    # Enter free exploration mode
    interactive_prompt

    # Mission complete!
    echo ""
    show_cat "${MISSION_SUCCESS_POSE:-celebrate}" "${MISSION_SUCCESS_MSG:-Mission Complete!}"
    echo ""
    read -r -p "Press Enter to continue... "
    echo ""
}

# ── Section Runner ─────────────────────────────────────────

run_section() {
    local section="$1"

    # Get section name and show banner
    local name_var="SECTION_${section}_NAME"
    local section_name="${!name_var:-Section $section}"
    show_section_banner "$section" "$section_name"

    # Get the space-separated list of lessons for this section
    local lessons_var="SECTION_${section}_LESSONS"
    local lessons_str="${!lessons_var:-}"

    if [[ -z "$lessons_str" ]]; then
        echo "Warning: No lessons found for section $section"
        return
    fi

    # Iterate through lessons
    for lesson_id in $lessons_str; do
        CURRENT_LESSON="$lesson_id"
        run_lesson "$lesson_id"
    done

    # Run section mission if defined
    local mission_var="SECTION_${section}_MISSION"
    local mission_id="${!mission_var:-}"
    if [[ -n "$mission_id" ]]; then
        run_mission "$mission_id"
    fi

    mark_section_complete "$section"
}

# ── Stage Runner (Main Entry) ─────────────────────────────

run_stage() {
    local stage_num="$1"

    # Load stage configuration
    load_stage "$stage_num"

    # sandbox.sh owns where the sandbox lives; just start the player in it.
    CURRENT_GAME_DIR="$SANDBOX_HOME"
    export SANDBOX_HOME CURRENT_GAME_DIR

    # Show stage banner
    show_stage_banner "$stage_num" "${STAGE_NAME:-}"

    # Run each section in order
    if [[ -n "${STAGE_SECTIONS:-}" ]]; then
        for section in $STAGE_SECTIONS; do
            CURRENT_SECTION="$section"
            run_section "$section"
        done
    fi

    # Run the final mission if defined
    if [[ -n "${FINAL_MISSION:-}" ]]; then
        echo ""
        show_cat "mission" "One last challenge awaits..."
        echo ""
        run_mission "$FINAL_MISSION"
    fi

    # Stage complete!
    mark_stage_complete "$stage_num"
}

# ── Game Runner (Main Entry) ──────────────────────────────

stage_exists() {
    [[ -f "${GAME_ROOT}/stages/stage${1}/stage.conf" ]]
}

# Each stage ships its own world template, so the sandbox is rebuilt when the
# player crosses into one. SANDBOX_STAGE is persisted, which keeps a resumed
# session from wiping the world the player is standing in.
prepare_stage_world() {
    local stage_num="$1"

    if [[ "${SANDBOX_STAGE:-}" == "$stage_num" ]] && sandbox_exists; then
        return 0
    fi

    reset_sandbox "$stage_num"
    populate_stage_files "$stage_num"
    SANDBOX_STAGE="$stage_num"
    save_progress
}

run_game() {
    local stage_num="${1:-1}"

    if ! stage_exists "$stage_num"; then
        show_cat "celebrate" "You have finished every stage. Nothing left to teach!"
        show_game_over_banner
        return 0
    fi

    unlock_prior_commands "$stage_num"

    while stage_exists "$stage_num"; do
        prepare_stage_world "$stage_num"
        run_stage "$stage_num"

        stage_num=$((stage_num + 1))

        if stage_exists "$stage_num"; then
            echo ""
            show_cat "celebrate" "Stage cleared! A harder one is waiting."
            echo ""
            read -r -p "Press Enter to start the next stage... "
            echo ""
        fi
    done

    show_game_over_banner
}
