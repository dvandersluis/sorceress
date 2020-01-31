#!/bin/bash

# Install xcode tools directly on the command line without needing to open a GUI
# Based on https://apple.stackexchange.com/a/195963

trap cleanup EXIT

placeholder="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

cleanup() {
  run_command rm -f $placeholder
}

install() {
  run_command touch $placeholder

  # Find xcode command line tools in softwareupdate
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n'
  )

  run_command softwareupdate -i "$PROD"
  run_command sudo xcode-select --switch /Library/Developer/CommandLineTools
}

# Ensure xcode isn't installed already
if ! xcode-select -p &> /dev/null; then
  install
fi
