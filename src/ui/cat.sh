#!/usr/bin/env bash
set -euo pipefail

# show_cat(pose, message)
show_cat() {
  local pose="${1:-default}"
  local message="${2:-}"
  local art_file="${GAME_ROOT}/assets/cat/${pose}.txt"

  if [[ ! -f "${art_file}" ]]; then
    art_file="${GAME_ROOT}/assets/cat/default.txt"
  fi

  echo -e "${YELLOW}"
  cat "${art_file}"
  echo -e "${RESET}"

  if [[ -n "${message}" ]]; then
    echo -e "${CYAN}${message}${RESET}"
  fi
}

# show_cat_says(pose, message)
show_cat_says() {
  local pose="${1:-default}"
  local message="${2:-}"
  
  show_cat "${pose}" ""
  
  # A simple speech bubble
  local len=${#message}
  local dashes=""
  for ((i=0; i<len+4; i++)); do dashes+="-"; done
  
  echo -e "${CYAN} ${dashes}"
  echo -e "< ${message} >"
  echo -e " ${dashes}${RESET}"
}
