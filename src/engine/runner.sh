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
    else
        echo "Error: Stage $stage_num config not found at $conf_file"
        exit 1
    fi
}

# ── Sandbox Command Execution ─────────────────────────────

execute_in_sandbox() {
    local cmd_line="$1"
    local cmd args

    # Split command and arguments
    cmd=$(echo "$cmd_line" | awk '{print $1}')
    args=$(echo "$cmd_line" | cut -d' ' -f2- -s)

    # Ensure we're in the right directory
    cd "$CURRENT_GAME_DIR" 2>/dev/null || true

    case "$cmd" in
        cd)
            local target_dir="$args"

            # Handle special cases
            if [[ -z "$target_dir" || "$target_dir" == "~" ]]; then
                CURRENT_GAME_DIR="$SANDBOX_HOME"
                return 0
            fi

            # Handle .. and relative paths
            local new_dir
            if [[ "$target_dir" == /* ]]; then
                # Absolute paths: remap /home/catplayer to sandbox
                new_dir=$(echo "$target_dir" | sed "s|^/home/catplayer|$SANDBOX_HOME|")
            else
                new_dir=$(cd "$CURRENT_GAME_DIR" && realpath -m "$target_dir" 2>/dev/null)
            fi

            # Safety: ensure we stay within sandbox
            if [[ "$new_dir" != "$SANDBOX_HOME"* ]]; then
                show_cat "warning" "Hey! You can't leave our game world!"
                return 1
            fi

            if [[ -d "$new_dir" ]]; then
                CURRENT_GAME_DIR="$new_dir"
            else
                echo "bash: cd: ${target_dir}: No such file or directory"
            fi
            ;;

        pwd)
            # Show the virtual path (as if /home/catplayer is real)
            local rel_path
            rel_path=$(realpath --relative-to="$SANDBOX_HOME" "$CURRENT_GAME_DIR" 2>/dev/null || echo ".")
            if [[ "$rel_path" == "." ]]; then
                echo "/home/catplayer"
            else
                echo "/home/catplayer/$rel_path"
            fi
            ;;

        ls)
            # Run ls in current game directory with any flags
            (cd "$CURRENT_GAME_DIR" && ls $args 2>&1)
            ;;

        cat)
            if [[ -z "$args" ]]; then
                echo "cat: missing file operand"
                return 1
            fi
            local target_file="${CURRENT_GAME_DIR}/${args}"
            if [[ -f "$target_file" ]]; then
                command cat "$target_file"
            else
                echo "cat: ${args}: No such file or directory"
            fi
            ;;

        less)
            if [[ -z "$args" ]]; then
                echo "less: missing file operand"
                return 1
            fi
            local target_file="${CURRENT_GAME_DIR}/${args}"
            if [[ -f "$target_file" ]]; then
                less "$target_file"
            else
                echo "less: ${args}: No such file or directory"
            fi
            ;;

        mkdir)
            local dir_args="$args"
            # Strip -p flag if present
            dir_args="${dir_args//-p /}"
            local target_path="${CURRENT_GAME_DIR}/${dir_args}"
            if [[ "$target_path" == "$SANDBOX_HOME"* ]]; then
                mkdir -p "$target_path"
            else
                echo "mkdir: permission denied"
            fi
            ;;

        touch)
            local target_path="${CURRENT_GAME_DIR}/${args}"
            if [[ "$target_path" == "$SANDBOX_HOME"* ]]; then
                touch "$target_path"
            else
                echo "touch: permission denied"
            fi
            ;;

        cp)
            local src dst
            src=$(echo "$args" | awk '{print $1}')
            dst=$(echo "$args" | awk '{print $2}')
            if [[ -z "$src" || -z "$dst" ]]; then
                echo "cp: missing operand"
                return 1
            fi
            local src_path="${CURRENT_GAME_DIR}/${src}"
            local dst_path="${CURRENT_GAME_DIR}/${dst}"
            if [[ -f "$src_path" && "$dst_path" == "$SANDBOX_HOME"* ]]; then
                cp "$src_path" "$dst_path"
            else
                echo "cp: cannot copy '${src}' to '${dst}'"
            fi
            ;;

        mv)
            local src dst
            src=$(echo "$args" | awk '{print $1}')
            dst=$(echo "$args" | awk '{print $2}')
            if [[ -z "$src" || -z "$dst" ]]; then
                echo "mv: missing operand"
                return 1
            fi
            local src_path="${CURRENT_GAME_DIR}/${src}"
            local dst_path="${CURRENT_GAME_DIR}/${dst}"
            if [[ -e "$src_path" && "$dst_path" == "$SANDBOX_HOME"* ]]; then
                mv "$src_path" "$dst_path"
            else
                echo "mv: cannot move '${src}' to '${dst}'"
            fi
            ;;

        rm)
            local target="$args"
            # Strip flags for safe_rm
            target="${target//-r /}"
            target="${target//-f /}"
            target="${target//-rf /}"
            target="${target//-fr /}"
            if [[ -z "$target" ]]; then
                echo "rm: missing operand"
                return 1
            fi
            local target_path="${CURRENT_GAME_DIR}/${target}"
            if [[ "$target_path" == "$SANDBOX_HOME"* ]]; then
                safe_rm "$target_path"
            else
                show_cat "warning" "You can't delete things outside our game world!"
            fi
            ;;

        *)
            show_cat "confused" "I don't know that command yet. Try 'help' to see what you've learned!"
            ;;
    esac
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
            # Trim whitespace
            input=$(echo "$input" | xargs 2>/dev/null || echo "$input")

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
                    execute_in_sandbox "$input"

                    # Track the base command as learned
                    local base_cmd
                    base_cmd=$(echo "$input" | awk '{print $1}')
                    add_learned_command "$base_cmd"

                    # Check if the current task is complete
                    if type check_task &>/dev/null; then
                        if check_task; then
                            task_complete=true
                            echo ""
                            show_cat "${TASK_SUCCESS_POSE:-happy}" "${TASK_SUCCESS_MSG:-Well done!}"
                            echo ""
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

    # Initialize the sandbox working directory
    SANDBOX_HOME="${GAME_ROOT}/sandbox/home/catplayer"
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
    show_game_over_banner
}
