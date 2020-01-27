#!/bin/bash
# shellcheck disable=SC2034

export NC='\033[0m'       # Text Reset

# Regular Colors
export Black='\033[0;30m'        # Black
export Red='\033[0;31m'          # Red
export Green='\033[0;32m'        # Green
export Yellow='\033[0;33m'       # Yellow
export Blue='\033[0;34m'         # Blue
export Purple='\033[0;35m'       # Purple
export Cyan='\033[0;36m'         # Cyan
export White='\033[0;37m'        # White

# Bold
export BBlack='\033[1;30m'       # Black
export BRed='\033[1;31m'         # Red
export BGreen='\033[1;32m'       # Green
export BYellow='\033[1;33m'      # Yellow
export BBlue='\033[1;34m'        # Blue
export BPurple='\033[1;35m'      # Purple
export BCyan='\033[1;36m'        # Cyan
export BWhite='\033[1;37m'       # White

cecho(){
  printf "${!1}%s$NC\n" "$2"
}

announce() {
  echo
  cecho BGreen "$1"
}

notice() {
  cecho BBlue "$1"
}

welcome() {
  cecho BPurple "$1"
}

warning() {
  >&2 cecho BYellow "$1"
}

error() {
  >&2 cecho BRed "$1"
}

abort() {
  echo
  error "$1"
  exit 1
}

result() {
  local ret=$?

  if (( ret == 0 )); then
    local emoji="✅"
  else
    local emoji="❌"
  fi

  printf "%s\n" "$emoji"
  return $ret
}

export -f cecho announce notice welcome warning error abort result
