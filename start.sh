#!/bin/bash
. lib/share/ui.sh

welcome 'Initializing Sorceress 🧙‍♀️'
. lib/spells/core/install_prerequisites.sh

ruby lib/sorceress/boot.rb
