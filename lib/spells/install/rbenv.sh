#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

brew_install rbenv ruby-build

run_command rbenv init
run_command "echo 'eval \"\$(rbenv init -)\"' >> ~/.bash_profile"
