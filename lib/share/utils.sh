#!/bin/bash
# shellcheck disable=SC1090

debug() {
  debug="$(echo "${SORCERESS_DEBUG:-0}" | tr '[:upper:]' '[:lower:]')"
  test "${debug}" != "0" -a "${debug}" != "false"
}

pretend() {
  pretend="$(echo "${SORCERESS_PRETEND:-0}" | tr '[:upper:]' '[:lower:]')"
  test "${pretend}" != "0" -a "${pretend}" != "false"
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

find_spell() {
  (
    IFS=':'
    find "$SORCERESS_LIBRARIES" -type f -perm +111 | grep "$1.sh"
  ) || abort "Spell not found: $1"
}

run_spell() {
  # Keep each argument separate
  oldifs=$IFS
  IFS=' '
  arguments=( "${@:2}" )
  IFS=$oldifs

  "$(find_spell "$1")" "${arguments[@]}"
}

# Output and run a command
run_command() {
  OLD_IFS=$IFS
  IFS=' '

  echo_command "$*"

  if ! pretend; then
    if debug; then
      eval "$*"
    else
      eval "$* &>/dev/null"
    fi
  fi

  res=$?

  IFS="${OLD_IFS}"
  return $res
}

version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1, $2, $3, $4); }'
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

export -f debug pretend fail abort find_spell run_spell run_command version find_version
