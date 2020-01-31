#!/bin/bash

version=$1

get_tags() {
  git ls-remote -t https://github.com/elastic/homebrew-tap.git |
    cut -f2 |
    cut -d'/' -f 3 |
    grep -v '\^{}' |
    tr -d v
}

# Ensure the requested version matches a tag
find_formula() {
  local tags
  tags=$(get_tags)
  local highest=${tags##*$'\n'}

  find_version "$tags" "$version"

  if [ "$version" == "$highest" ]; then
    formula="elasticsearch-full"
  else
    formula="https://raw.githubusercontent.com/elastic/homebrew-tap/v$version/Formula/elasticsearch-full.rb"
  fi
}

install() {
  announce "Installing elasticsearch v$version"
  run_command brew tap elastic/tap
  run_command brew install "$formula"
}

upgrade() {
  announce "Upgrading elasticsearch to v$version"
  warn_upgrade

  run_command brew tap elastic/tap
  run_command HOMEBREW_NO_INSTALL_CLEANUP=1 brew upgrade "$formula"
}

warn_upgrade() {
  note "$({
    printf "Existing version will be retained and can be returned to using "
    bold "brew switch elasticsearch-full <version>"
    printf "."
  })"
  echo
}

do_install() {
  if brew_installed elasticsearch-full; then
    upgrade
  else
    install
  fi
}

if [ -n "$version" ] && [ "$(version "$version")" -lt "$(version "7")" ]; then
  abort "Installing elasticsearch < 7 requires a different brew package and is not currently supported."
fi

find_formula && do_install
