module Sorceress
  module Spells
    class Abracadabra < Spell
      def call
        welcome('Abracadabra! 🔮')
        Sorceress::Incantation.new.call

      rescue SpellError => e
        abort(e.message)

      rescue StandardError => e
        if Sorceress.debug_mode?
          debug(e)
        else
          abort(e.message)
        end
      end

    private

      def debug(exception)
        $stderr.puts
        error(exception.message)
        $stderr.puts exception.backtrace.join("\n")
        abort
      end
    end
  end
end
