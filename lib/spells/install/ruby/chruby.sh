#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

version="${1:--latest}"

run_command "source ~/.bash_profile"
run_command "ruby-install --no-reinstall ruby $version"
run_command "chruby-exec $version -- gem install bundler"
