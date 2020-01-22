module Sorceress
  class Spellbook
    class Steps
      def initialize(default_spellbook, user_spellbook)
        @default_spellbook = default_spellbook
        @user_spellbook = user_spellbook
      end

      def extract
        steps = user_spellbook.fetch('steps', []).empty? ? default_spellbook['steps'] : user_spellbook['steps']
        default_spellbook['prerequisites'].concat(Array(steps))
      end

    private

      attr_reader :default_spellbook, :user_spellbook
    end
  end
end
