#!/usr/bin/env bash
# Review: tar (S8) + sha256sum (S8) + chaining (S9)

TASK_INSTRUCTION="Archive the site/ directory into site.tar.gz and, only if that succeeds, write its checksum to site.sha256 — joined into one line."
TASK_CAT_POSE="thinking"
RECALLS="Stage 8 — tar, sha256sum · Stage 9 — &&"

TASK_SUCCESS_MSG="Bundled and fingerprinted, with the second step conditional on the first. Stage 8 and Stage 9 in one line."
TASK_SUCCESS_POSE="happy"
TASK_FAIL_MSG="Both files must exist, and the two commands must be joined with &&."
TASK_FAIL_POSE="confused"

HINT_1="Two commands, the second only if the first worked."
HINT_2="tar -czf ... && sha256sum ... > ..."
HINT_3="Run: tar -czf site.tar.gz site && sha256sum site.tar.gz > site.sha256"

setup_challenge() {
    ensure_sandbox_dir "${SANDBOX_HOME}/site"
    rm -f "${SANDBOX_HOME}/site.tar.gz" "${SANDBOX_HOME}/site.sha256"
    printf 'home\nabout\n' > "${SANDBOX_HOME}/site/pages.txt"
}

check_task() {
    check_command_matches '&&' \
        && check_file_exists "site.tar.gz" \
        && check_file_exists "site.sha256" \
        && ( cd "${SANDBOX_HOME}" && sha256sum -c site.sha256 >/dev/null 2>&1 )
}
