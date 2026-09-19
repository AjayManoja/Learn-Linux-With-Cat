#!/usr/bin/env bash
set -euo pipefail

# Check if terminal supports colors
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  export RED='\033[0;31m'
  export GREEN='\033[0;32m'
  export YELLOW='\033[0;33m'
  export BLUE='\033[0;34m'
  export CYAN='\033[0;36m'
  export MAGENTA='\033[0;35m'
  export BOLD='\033[1m'
  export DIM='\033[2m'
  export ITALIC='\033[3m'
  export UNDERLINE='\033[4m'
  export RESET='\033[0m'
else
  export RED=''
  export GREEN=''
  export YELLOW=''
  export BLUE=''
  export CYAN=''
  export MAGENTA=''
  export BOLD=''
  export DIM=''
  export ITALIC=''
  export UNDERLINE=''
  export RESET=''
fi
