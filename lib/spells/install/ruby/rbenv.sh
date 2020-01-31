#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

version="$1"


run_command "rbenv install --skip-existing $version"

# Initialize rbenv
eval "$(rbenv init -)"
run_command rbenv shell "$version"
run_command gem install bundler --conservative
run_command rbenv shell --unset
