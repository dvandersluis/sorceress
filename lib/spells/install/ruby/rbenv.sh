#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

version="$1"


run_command "rbenv install --skip-existing $version"

echo_command 'eval "$(rbenv init -)"'
pretend || eval "$(rbenv init -)"

run_command rbenv shell "$version"
run_command gem install bundler
run_command rbenv shell --unset
