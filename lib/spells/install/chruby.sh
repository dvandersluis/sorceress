#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

brew_install chruby ruby-install

run_command "echo 'source /usr/local/opt/chruby/share/chruby/chruby.sh' >> ~/.bash_profile"
run_command "echo 'source /usr/local/opt/chruby/share/chruby/auto.sh' >> ~/.bash_profile"
