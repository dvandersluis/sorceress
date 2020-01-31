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
export Grey='\e[90m'

# Bold
export BBlack='\033[1;30m'       # Black
export BRed='\033[1;31m'         # Red
export BGreen='\033[1;32m'       # Green
export BYellow='\033[1;33m'      # Yellow
export BBlue='\033[1;34m'        # Blue
export BPurple='\033[1;35m'      # Purple
export BCyan='\033[1;36m'        # Cyan
export BWhite='\033[1;37m'       # White

export notice_counter=0

cecho() {
  if [ $# -eq 3 ]; then
    printf "${!1}%s$NC " "$2"
  else
    printf "${!1}%s$NC\n" "$2"
  fi
}

bold() {
  tput bold
  printf "%s" "$1"
  tput sgr0
}

announce() {
  echo
  cecho BGreen "⇒ $(tput smul)$1$(tput rmul)"
}

note() {
  bold "Note: "
  printf "%s\n" "$1"
}

notice() {
  notice_counter=$(( notice_counter + 1 ))
  if [ $notice_counter -gt 1 ]; then
    echo
  fi

  cecho Blue "$1"
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

fail() {
  res=$?
  cecho BRed "$1"
  exit $res
}

abort() {
  echo
  error "$1"
  error "Sorceress was unable to successfully perform the incantation."
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

long_result() {
  local ret=$?

  echo

  if (( ret == 0 )); then
    cecho Green "✅ ${1:-Done}"
  else
    cecho Red "❌ Failed"
  fi

  return $ret
}

export -f cecho bold announce note notice welcome warning error fail abort result long_result
