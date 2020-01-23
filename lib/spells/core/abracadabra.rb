module Sorceress
  module Spells
    class Abracadabra < Spell
      def call
        Sorceress::Incantation.new.call

      rescue SpellError => e
        abort(e.message)

      rescue StandardError
        abort
      end
    end
  end
end
