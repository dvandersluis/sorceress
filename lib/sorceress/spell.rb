require 'sorceress/spell/find'

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
