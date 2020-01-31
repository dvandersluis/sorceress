#!/bin/bash
set -o pipefail

. lib/share/includes.sh

(
  welcome 'Initializing Sorceress 🧙‍♀️'

  lib/spells/core/install_prerequisites.sh &&
    lib/spells/core/enable_sudo.sh &&
    ruby lib/sorceress/boot.rb
) > >(tee /tmp/sorceress.log) 2>&1

if [ ${PIPESTATUS[0]} -eq 0 ]; then
  echo
  welcome "Installation complete! ✨"
fi

printf "Log saved at %s.\n" $(bold "/tmp/sorceress.log")
