#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

brew_install openssl libyaml libffi asdf

run_command 'echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.bash_profile'
run_command 'echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> ~/.bash_profile'

run_command 'asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git'
run_command 'echo "legacy_version_file = yes" >> ~/.asdfrc'
