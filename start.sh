#!/bin/bash
. lib/share/ui.sh
. lib/share/utils.sh

welcome 'Initializing Sorceress 🧙‍♀️'
. lib/spells/core/install_prerequisites.sh

announce 'Enabling sudo access'
sudo echo 'sudo enabled' > /dev/null
if (( $? == 0 )); then
  echo "Sudo enabled ✅"
else
  abort 'Sudo access is requested to allow scripts to use sudo as necessary.'
fi

ruby lib/sorceress/boot.rb
