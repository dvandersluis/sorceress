#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

version="${1:--latest}"
run_command "ruby-install --no-reinstall ruby $version"
run_command "chruby $version -- gem install bundler --conservative"
