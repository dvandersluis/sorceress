#!/bin/bash
# shellcheck disable=SC1090

run_spell() {
  . "lib/spells/$1.sh" "${@:2}"
}

export -f run_spell
