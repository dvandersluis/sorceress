require 'sorceress/spell/find'
require 'sorceress/spell/locate_script'

module Sorceress
  class Spell
    include CLI
    extend Find

    def context
      Sorceress.context
    end

    def spellbook
      context.spellbook
    end

    def artifacts
      context.artifacts
    end
  end
end
