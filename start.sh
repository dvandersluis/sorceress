#!/bin/bash

. lib/share/includes.sh

(
  welcome 'Initializing Sorceress 🧙‍♀️'

  lib/spells/core/install_prerequisites.sh &&
    lib/spells/core/enable_sudo.sh &&
    ruby lib/sorceress/boot.rb
) | tee /tmp/sorceress.log

echo
welcome "Installation complete! ✨"
printf "Log saved at %s.\n" $(bold "/tmp/sorceress.log")
