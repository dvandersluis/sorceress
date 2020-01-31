#!/bin/bash

if [ -z "${CI}" ]; then
  announce 'Enabling sudo access'

  if sudo -v; then
    long_result "Enabled"
  else
    abort 'Sudo access is requested to allow scripts to use sudo as necessary.'
  fi
fi
