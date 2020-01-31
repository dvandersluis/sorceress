#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

version="$1"

run_command 'source $HOME/.rvm/scripts/rvm'
run_command "rvm install $version"
run_command "rvm $version do gem install bundler"
