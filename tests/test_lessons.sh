#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/world/sandbox.sh"
source "$REPO_ROOT/src/world/filesystem.sh"
source "$REPO_ROOT/src/world/maze.sh"
source "$REPO_ROOT/src/engine/checker.sh"
source "$REPO_ROOT/src/engine/hints.sh"
source "$REPO_ROOT/src/ui/colors.sh"
source "$REPO_ROOT/src/ui/cat.sh"
source "$REPO_ROOT/src/engine/history.sh"
# runner.sh supplies the background-job helpers some missions set up with.
source "$REPO_ROOT/src/engine/runner.sh"

echo "Testing that lessons actually verify their task..."

# A check that cannot even run looks exactly like a check that correctly
# rejects: both return non-zero. `bash -n` does not catch it either, because
# an =~ pattern is only parsed when the line executes — a bare space outside
# parentheses ends the pattern and raises "syntax error in conditional
# expression" at that moment. So call every check and read its stderr.
check_runs_cleanly() {
    local file="$1" label="$2" errors
    errors=$( ( set +u
                unset -f check_task check_mission
                source "$file" 2>/dev/null
                LAST_COMMAND="probe_command"
                CURRENT_GAME_DIR="${SANDBOX_HOME:-/tmp}"
                for fn in check_task check_mission; do
                    type "$fn" >/dev/null 2>&1 && "$fn" >/dev/null
                done ) 2>&1 ) || true

    if grep -qE 'syntax error|command not found|unbound variable' <<< "$errors"; then
        fail "$label check errors when run: $(head -1 <<< "$errors")"
    else
        pass "$label check runs without error"
    fi
}

# The invariant: in a freshly built world, with a command that has nothing to
# do with the lesson, no check_task may pass. A lesson that returns 0
# regardless announces "Well done!" for whatever the player typed and moves on,
# which is indistinguishable from the game being broken.

shopt -s nullglob
stage_dirs=("$REPO_ROOT"/stages/stage*/)
shopt -u nullglob

for stage_dir in "${stage_dirs[@]}"; do
    stage_dir="${stage_dir%/}"
    stage_id="$(basename "$stage_dir")"
    stage_num="${stage_id#stage}"

    create_sandbox "$stage_num" >/dev/null 2>&1 || continue
    populate_stage_files "$stage_num" >/dev/null 2>&1 || true

    for lesson_file in "$stage_dir"/lessons/*.sh; do
        [[ -f "$lesson_file" ]] || continue
        lesson_name="$(basename "$lesson_file" .sh)"

        # `|| rc=$?` keeps the failing subshell out of set -e's way; a bare
        # subshell here would abort the run before the case is reached.
        rc=0
        (
            set +u
            unset -f check_task
            source "$lesson_file"

            # Nonsense input, and the player standing where they start.
            LAST_COMMAND="zzz_not_a_real_command --nonsense"
            CURRENT_GAME_DIR="$SANDBOX_HOME"

            type check_task >/dev/null 2>&1 || exit 2
            check_task >/dev/null 2>&1
        ) || rc=$?
        case $rc in
            0) fail "$stage_id/$lesson_name passes on an unrelated command" ;;
            2) fail "$stage_id/$lesson_name defines no check_task" ;;
            *) pass "$stage_id/$lesson_name rejects an unrelated command" ;;
        esac
        check_runs_cleanly "$lesson_file" "$stage_id/$lesson_name"
    done

    # Review challenges are questions, so passing one without answering is
    # exactly as bad as a lesson that checks nothing.
    for challenge_file in "$stage_dir"/review/*.sh; do
        [[ -f "$challenge_file" ]] || continue
        challenge_name="$(basename "$challenge_file" .sh)"

        rc=0
        (
            set +u
            unset -f check_task setup_challenge
            source "$challenge_file"
            type setup_challenge >/dev/null 2>&1 && setup_challenge >/dev/null 2>&1
            LAST_COMMAND="zzz_not_a_real_command --nonsense"
            CURRENT_GAME_DIR="$SANDBOX_HOME"
            type check_task >/dev/null 2>&1 || exit 2
            check_task >/dev/null 2>&1
        ) || rc=$?
        case $rc in
            0) fail "$stage_id/review/$challenge_name passes on an unrelated command" ;;
            2) fail "$stage_id/review/$challenge_name defines no check_task" ;;
            *) pass "$stage_id/review/$challenge_name rejects an unrelated command" ;;
        esac
        check_runs_cleanly "$challenge_file" "$stage_id/review/$challenge_name"

        rerun_rc=0
        (
            set +u
            unset -f setup_challenge
            source "$challenge_file"
            type setup_challenge >/dev/null 2>&1 || exit 0
            setup_challenge >/dev/null 2>&1
            setup_challenge >/dev/null 2>&1
        ) || rerun_rc=$?
        [[ "$rerun_rc" -eq 0 ]]             && pass "$stage_id/review/$challenge_name setup can run twice"             || fail "$stage_id/review/$challenge_name setup fails on a second run"
    done

    # Same invariant for missions: none may be complete the moment it starts.
    for mission_file in "$stage_dir"/missions/*.sh; do
        [[ -f "$mission_file" ]] || continue
        mission_name="$(basename "$mission_file" .sh)"

        rc=0
        (
            set +u
            unset -f check_mission setup_mission
            source "$mission_file"
            type setup_mission >/dev/null 2>&1 && setup_mission >/dev/null 2>&1

            LAST_COMMAND="zzz_not_a_real_command --nonsense"
            CURRENT_GAME_DIR="$SANDBOX_HOME"

            type check_mission >/dev/null 2>&1 || exit 2
            check_mission >/dev/null 2>&1
        ) || rc=$?
        case $rc in
            0) fail "$stage_id/$mission_name is already complete at its briefing" ;;
            2) fail "$stage_id/$mission_name defines no check_mission" ;;
            *) pass "$stage_id/$mission_name starts incomplete" ;;
        esac
        check_runs_cleanly "$mission_file" "$stage_id/$mission_name"

        # Setup must survive being run twice. A player who quits partway
        # through a mission runs it again on their next session, and a setup
        # that cannot cope with the state it left behind takes the whole game
        # down with it — mission scripts carry their own `set -e`.
        rerun_rc=0
        (
            set +u
            unset -f setup_mission
            source "$mission_file"
            type setup_mission >/dev/null 2>&1 || exit 0
            setup_mission >/dev/null 2>&1
            setup_mission >/dev/null 2>&1
        ) || rerun_rc=$?
        if [[ "$rerun_rc" -eq 0 ]]; then
            pass "$stage_id/$mission_name setup can run twice"
        else
            fail "$stage_id/$mission_name setup fails on a second run"
        fi

        # Some missions launch real processes; do not leave them running.
        pid_file="$(game_pid_file)"
        if [[ -f "$pid_file" ]]; then
            while read -r stray; do
                [[ -n "$stray" ]] && kill "$stray" 2>/dev/null || true
            done < "$pid_file"
            rm -f "$pid_file"
        fi
    done

    destroy_sandbox
done

finish "Lesson verification tests"
