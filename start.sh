#!/bin/bash
. lib/share/ui.sh
. lib/share/utils.sh

welcome 'Initializing Sorceress 🧙‍♀️'
. lib/spells/core/install_prerequisites.sh

ruby lib/sorceress/boot.rb
