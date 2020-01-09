#!/bin/bash
. lib/share/ui.sh

welcome 'Initializing Sorceress 🧙‍♀️'
. lib/spells/install/prerequisites.sh

ruby lib/sorceress/boot.rb
