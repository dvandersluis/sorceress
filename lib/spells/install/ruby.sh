#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

version="$1"
# shellcheck disable=SC2206
managers=($2)
manager=

. lib/share/includes.sh

find_manager() {
  notice "Detecting ruby version managers"

  declare -a available_managers

  for m in "${managers[@]}"; do
    printf "%s... " "$m"
    if result "$(which "$m")"; then
      available_managers+=("$m")
    fi
  done

  if [ ${#available_managers[@]} -eq 0 ]; then
    return 1
  fi

  manager="${available_managers[0]}"
}

install_manager() {
  manager=$1
  notice "Installing $manager"
  run_spell "install/$manager" || abort "Sorry, no install script was found for $manager"
}

install_ruby() {
  notice "Installing ruby with $manager"
  run_spell "install/ruby/$manager" "$version" || abort "Sorry, no install script was found for $manager"
}

announce "Installing ruby v$version"
{ find_manager || install_manager "${managers[0]}"; } &&
  install_ruby
