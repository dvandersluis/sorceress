module Sorceress
  module Spells
    class Abracadabra < Spell
      def call
        welcome('Abracadabra! 🔮')
        Sorceress::Incantation.new.call

      rescue SpellError => e
        abort(e.message)

      rescue StandardError => e
        abort(e.message)
      end
    end
  end
end
