module Sorceress
  class Incantation
    def call
      spells.each(&method(:invoke_spell))
    end

  private

    def invoke_spell(spell)
      spell.call
    end

    def spells
      @spells ||= Sorceress.spellbook.steps.map do |spell|
        Spell.find(spell)
      end
    end
  end
end
