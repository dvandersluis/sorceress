#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

brew_version() {
  # shellcheck disable=SC2016
  brew info "$1" | head -n1 | ruby -ne 'puts $_.scan(/\d+\.\d+(?:\.\d+)?/).first'
}

brew_install() {
  run_command brew update
  run_command brew install "$@"
}

brew_installed() {
  brew list "$1" &>/dev/null
}

export -f brew_version brew_install brew_installed
