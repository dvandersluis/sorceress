#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

version="${1:-latest}"

run_command "source ~/.bash_profile"
run_command 'echo "bundler" >> ~/.default-gems'
run_command "asdf install ruby $version"
