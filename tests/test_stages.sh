#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"
make_test_root
source "$REPO_ROOT/src/world/sandbox.sh"
source "$REPO_ROOT/src/world/filesystem.sh"
source "$REPO_ROOT/src/world/maze.sh"
source "$REPO_ROOT/src/engine/checker.sh"
source "$REPO_ROOT/src/engine/hints.sh"

echo "Testing stage structure..."

# Walks every stage that exists, so stages added later are covered without
# touching this file. The point is that each one is loadable and complete:
# a stage whose conf names a lesson file that isn't there dies mid-game.
shopt -s nullglob
stage_dirs=("$REPO_ROOT"/stages/stage*/)
shopt -u nullglob

if [[ ${#stage_dirs[@]} -eq 0 ]]; then
    fail "no stages found"
    finish "Stage structure tests"
fi

for stage_dir in "${stage_dirs[@]}"; do
    stage_dir="${stage_dir%/}"
    stage_id="$(basename "$stage_dir")"
    stage_num="${stage_id#stage}"
    conf="$stage_dir/stage.conf"

    assert_path_exists "$stage_id: has a stage.conf" "$conf"
    [[ -f "$conf" ]] || continue

    # Read the conf in a subshell-free way: the runner sources it too.
    ( set +u; source "$conf" ) >/dev/null 2>&1 \
        && pass "$stage_id: stage.conf sources cleanly" \
        || fail "$stage_id: stage.conf has a syntax error"

    set +u
    STAGE_NAME=""; STAGE_SECTIONS=""; STAGE_COMMANDS=""; FINAL_MISSION=""; STAGE_REVIEW=""
    source "$conf"
    set -u

    [[ -n "$STAGE_NAME" ]]     && pass "$stage_id: declares a name"     || fail "$stage_id: no STAGE_NAME"
    [[ -n "$STAGE_SECTIONS" ]] && pass "$stage_id: declares sections"   || fail "$stage_id: no STAGE_SECTIONS"
    [[ -n "$STAGE_COMMANDS" ]] && pass "$stage_id: declares commands"   || fail "$stage_id: no STAGE_COMMANDS"
    assert_path_exists "$stage_id: ships a world template" "$stage_dir/world/home/catplayer"

    for section in $STAGE_SECTIONS; do
        lessons_var="SECTION_${section}_LESSONS"
        mission_var="SECTION_${section}_MISSION"
        lessons="${!lessons_var:-}"
        mission="${!mission_var:-}"

        [[ -n "$lessons" ]] \
            && pass "$stage_id/$section: lists lessons" \
            || fail "$stage_id/$section: no lessons listed"

        for lesson in $lessons; do
            lesson_file="$stage_dir/lessons/${lesson}.sh"
            if [[ ! -f "$lesson_file" ]]; then
                fail "$stage_id/$section: missing lesson file ${lesson}.sh"
                continue
            fi
            bash -n "$lesson_file" 2>/dev/null \
                && pass "$stage_id: ${lesson}.sh parses" \
                || fail "$stage_id: ${lesson}.sh has a syntax error"

            # Every lesson must define the function the runner calls, and the
            # three hints the player can ask for.
            ( set +u; unset -f check_task; source "$lesson_file"
              [[ -n "${TASK_INSTRUCTION:-}" && -n "${HINT_3:-}" ]] && type check_task >/dev/null 2>&1 ) \
                && pass "$stage_id: ${lesson}.sh is complete" \
                || fail "$stage_id: ${lesson}.sh missing check_task, TASK_INSTRUCTION or HINT_3"
        done

        if [[ -n "$mission" ]]; then
            assert_path_exists "$stage_id/$section: mission ${mission}.sh exists" \
                "$stage_dir/missions/${mission}.sh"
        fi
    done

    # Review checkpoints: every challenge named must exist and be complete.
    for challenge in ${STAGE_REVIEW:-}; do
        challenge_file="$stage_dir/review/${challenge}.sh"
        if [[ ! -f "$challenge_file" ]]; then
            fail "$stage_id: missing review challenge ${challenge}.sh"
            continue
        fi
        bash -n "$challenge_file" 2>/dev/null             && pass "$stage_id: review ${challenge}.sh parses"             || fail "$stage_id: review ${challenge}.sh has a syntax error"
        ( set +u; unset -f check_task; source "$challenge_file"
          [[ -n "${TASK_INSTRUCTION:-}" && -n "${HINT_3:-}" && -n "${RECALLS:-}" ]]             && type check_task >/dev/null 2>&1 )             && pass "$stage_id: review ${challenge}.sh is complete"             || fail "$stage_id: review ${challenge}.sh missing check_task, TASK_INSTRUCTION, HINT_3 or RECALLS"
    done

    if [[ -n "$FINAL_MISSION" ]]; then
        assert_path_exists "$stage_id: final mission exists" \
            "$stage_dir/missions/${FINAL_MISSION}.sh"
    fi

    for mission_file in "$stage_dir"/missions/*.sh; do
        [[ -f "$mission_file" ]] || continue
        mission_name="$(basename "$mission_file" .sh)"
        bash -n "$mission_file" 2>/dev/null \
            && pass "$stage_id: ${mission_name}.sh parses" \
            || fail "$stage_id: ${mission_name}.sh has a syntax error"
        ( set +u; unset -f check_mission; source "$mission_file"
          [[ -n "${MISSION_BRIEFING:-}" ]] && type check_mission >/dev/null 2>&1 ) \
            && pass "$stage_id: ${mission_name}.sh is complete" \
            || fail "$stage_id: ${mission_name}.sh missing check_mission or MISSION_BRIEFING"
    done

    # The world must actually build, and populate_stage_files must not error.
    if create_sandbox "$stage_num" >/dev/null 2>&1; then
        pass "$stage_id: sandbox builds from its template"
        populate_stage_files "$stage_num" >/dev/null 2>&1 \
            && pass "$stage_id: populate_stage_files succeeds" \
            || fail "$stage_id: populate_stage_files failed"
    else
        fail "$stage_id: sandbox failed to build"
    fi
    destroy_sandbox
done

# Stages must be numbered without gaps, or run_game stops at the hole.
highest=0
for stage_dir in "${stage_dirs[@]}"; do
    n="$(basename "${stage_dir%/}")"; n="${n#stage}"
    [[ "$n" =~ ^[0-9]+$ ]] || continue
    (( n > highest )) && highest="$n"
done
gaps=""
for (( i = 1; i <= highest; i++ )); do
    [[ -f "$REPO_ROOT/stages/stage${i}/stage.conf" ]] || gaps="${gaps} ${i}"
done
[[ -z "$gaps" ]] \
    && pass "stages 1..${highest} are contiguous" \
    || fail "missing stages:${gaps} — run_game would stop before them"

finish "Stage structure tests"
