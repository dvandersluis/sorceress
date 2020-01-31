#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

version="$1"
run_command "rbenv install $version"
run_command "rvm do $version gem install bundler"
