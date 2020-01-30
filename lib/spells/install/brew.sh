#!/bin/bash

ensure_xcode() {
  step 'Ensuring xcode command line tools are installed:'
  result "$(xcode-select -p)" || install_xcode
}

install_xcode() {
  step 'Installing xcode command line tools... '
  run_spell 'install/xcode'
  result
}

install_brew() {
  step 'Installing homebrew...'

  export CI=true # Skips the homebrew installer asking for input
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 1>&2
  result
}

announce 'Installing Homebrew'
ensure_xcode && install_brew
