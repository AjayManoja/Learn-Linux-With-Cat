#!/usr/bin/env bash
set -euo pipefail

MISSION_TITLE="The Missing Recipe"
MISSION_CAT_POSE="mission"
MISSION_BRIEFING="Someone hid a recipe card somewhere in my library. 🍽️
I know two things about it: the file's name ends in .card,
and it mentions a fish. Track it down with find, then read it.
Searching is the point here — don't wander the folders by hand."
MISSION_SUCCESS_MSG="Found and read, without opening a single wrong file!"
MISSION_SUCCESS_POSE="celebrate"
HINT_1="You know a command that searches for files by name pattern."
HINT_2="Try: find . -name \"*.card\" — then read what it turns up."
HINT_3="The card is at ${SEARCH_CARD_PATH:-library/...}. Read it with cat."

setup_mission() {
    local spots=("library/shelf_a" "library/shelf_b" "library/back_room")
    local spot="${spots[$((RANDOM % ${#spots[@]}))]}"

    # Global: check_mission and the final hint both need the chosen location.
    SEARCH_CARD_PATH="${spot}/lost_recipe.card"

    mkdir -p "${SANDBOX_HOME}/${spot}"
    cat > "${SANDBOX_HOME}/${SEARCH_CARD_PATH}" <<'CARD'
RECIPE CARD
Dish: Midnight Tuna
Time: 12 minutes
Note: the best fish is the one nobody offered you.
CARD

    set_hints \
        "You know a command that searches for files by name, not by contents." \
        "Try: find . -name \"*.card\"" \
        "The card is at ${SEARCH_CARD_PATH}. Read it with: cat ${SEARCH_CARD_PATH}"
}

check_mission() {
    # Completed by actually reading the card the search turns up.
    [[ "${LAST_COMMAND:-}" =~ ^(cat|head|tail|less)\ +.*lost_recipe\.card ]]
}
