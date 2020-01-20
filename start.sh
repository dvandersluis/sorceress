#!/bin/bash
. lib/share/ui.sh

welcome 'Initializing Sorceress 🧙‍♀️'
. lib/spells/install_prerequisites.sh

ruby lib/sorceress/boot.rb
