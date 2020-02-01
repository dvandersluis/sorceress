#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

version="$1"

if [ -f "$HOME/.rvm/scripts/rvm" ]; then
  run_command 'source $HOME/.rvm/scripts/rvm' || true
fi

run_command "rvm install $version"
run_command "rvm $version do gem install bundler"
