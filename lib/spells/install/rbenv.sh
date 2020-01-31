#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

brew_install rbenv ruby-build
run_command "echo 'eval \"\$(rbenv init -)\"' >> ~/.bash_profile"

echo_command 'eval "$(rbenv init -)"'
# shellcheck disable=SC2211
pretend? || eval "$(rbenv init -)"
