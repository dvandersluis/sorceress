#!/bin/bash

brew_version() {
  # shellcheck disable=SC2016
  brew info "$1" | head -n1 | ruby -ne 'puts $_.scan(/\d+\.\d+(?:\.\d+)?/).first'
}
