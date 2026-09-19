#!/usr/bin/env bash
set -euo pipefail

show_welcome_banner() {
  local line="========================================"
  echo -e "${CYAN}${line}"
  echo -e "      LEARN LINUX WITH CAT"
  echo -e "${line}${RESET}"
  
  show_cat "celebrate" ""
  
  echo -e "${CYAN}${line}"
  echo -e "  Your purr-fect journey starts here!  "
  echo -e "${line}${RESET}"
}

show_stage_banner() {
  local stage_number="${1:-}"
  local stage_name="${2:-}"
  local line="----------------------------------------"
  
  echo -e "${MAGENTA}${line}"
  echo -e "  STAGE ${stage_number}: ${stage_name}"
  echo -e "${line}${RESET}"
}

show_section_banner() {
  local section_letter="${1:-}"
  local section_name="${2:-}"
  
  echo -e "${BLUE}>> Section ${section_letter}: ${section_name}${RESET}"
}

show_game_over_banner() {
  local line="========================================"
  echo -e "${GREEN}${line}"
  echo -e "        CONGRATULATIONS!"
  echo -e "${line}${RESET}"
  
  show_cat "happy" "You've mastered the command line!"
}
