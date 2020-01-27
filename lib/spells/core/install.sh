#!/bin/bash

name=$1
version=$2

if [ -z "$version" ]; then
  announce "Installing $name"
else
  announce "Installing $1 v$version"
fi
