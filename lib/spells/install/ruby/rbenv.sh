#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

version="$1"
run_command "rbenv install $version"
run_command "rbenv shell $version"
run_command gem install bundler
run_command rbenv shell --unset
