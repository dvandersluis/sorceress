#!/bin/bash

ensure_xcode() {
  notice 'Ensuring xcode command line tools are installed'
  run_command xcode-select -p || install_xcode
}

install_xcode() {
  notice 'Installing xcode command line tools'
  run_spell 'install/xcode'
}

install_brew() {
  notice 'Installing homebrew'

  run_command export CI=true # Skips the homebrew installer asking for input

  # shellcheck disable=SC2016
  run_command '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'

  long_result
}

announce 'Installing Homebrew'
ensure_xcode && install_brew
