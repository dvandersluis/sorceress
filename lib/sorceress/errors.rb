module Sorceress
  class SpellError < StandardError
    attr_reader :spell

    def initialize(spell)
      @spell = spell
      super(message)
    end

    def message
      (self.class::MSG % message_args).strip
    end

    def message_args
      [spell]
    end
  end

  class SpellNotFound < SpellError
    MSG = <<-MSG.freeze
      %s spell could not be found.
    MSG
  end

  class InvalidSpell < SpellError
    MSG = <<-MSG.freeze
      %s is not a valid spell. Please ensure that it inherits from Sorceress::Spell.
    MSG
  end
end
