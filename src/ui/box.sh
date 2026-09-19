#!/usr/bin/env bash
set -euo pipefail

draw_dashed_line() {
  local width="${1:-40}"
  local line=""
  for ((i=0; i<width; i++)); do line+="-"; done
  echo "${line}"
}

show_lesson_box() {
  local title="${1:-Lesson}"
  local content="${2:-}"
  local width=40

  echo -e "${BOLD}${title}${RESET}"
  draw_dashed_line "${width}"
  echo -e "${content}"
  draw_dashed_line "${width}"
}

show_task_box() {
  local instruction="${1:-}"
  echo -e "✅  ${BOLD}${instruction}${RESET}"
}

show_mission_box() {
  local title="${1:-Mission}"
  local content="${2:-}"
  local width=40
  
  echo -e "🧩  ${BOLD}${title}${RESET}"
  draw_dashed_line "${width}"
  echo -e "${content}"
  draw_dashed_line "${width}"
}

show_success_box() {
  local message="${1:-}"
  echo -e "${GREEN}✅ ${message}${RESET}"
}

show_error_box() {
  local message="${1:-}"
  echo -e "${RED}❌ ${message}${RESET}"
}

show_info_box() {
  local message="${1:-}"
  echo -e "${BLUE}ℹ️  ${message}${RESET}"
}
