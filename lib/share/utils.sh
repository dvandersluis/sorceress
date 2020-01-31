#!/bin/bash
# shellcheck disable=SC1090

run_spell() {
  "lib/spells/$1.sh" "${@:2}"
}

# Output and run a command
run_command() {
  cecho Grey "→ $*"
  eval "$* &>/dev/null"
  res=$?
  return $res
}

version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1, $2, $3, $4); }';
}

# Find the closest matching version among a list
find_version() {
  local versions
  versions="$(echo "$1" | sort)"

  local lowest=${versions%%$'\n'*}
  local highest=${versions##*$'\n'}

  if [ -z "$2" ] || [ "$2" == "$highest" ]; then
    version=$highest
  elif ! echo "$versions" | grep -xq "$2" && echo "$versions" | grep -q "$2"; then
    version=$(echo "$versions" | grep "$2" | tail -n1)
  elif [ "$(version "$2")" -lt "$(version "$lowest")" ]; then
    version=$lowest
  elif [ "$(version "$2")" -gt "$(version "$highest")" ]; then
    version=$highest
  fi

  export version
}

export -f run_spell run_command version find_version
