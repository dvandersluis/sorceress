#!/bin/bash
# shellcheck disable=SC2034

NC='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

cecho(){
  printf "${!1}%s$NC\n" "$2"
}

announce() {
  echo
  cecho BGreen "$1"
}

info() {
  cecho BBlue "$1"
}

warning() {
  cecho BYellow "$1"
}

error() {
  cecho BRed "$1"
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
