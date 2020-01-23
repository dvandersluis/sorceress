module Sorceress
  module Spells
    class RunScript < Spell
      def initialize(script_path)
        @script_path = script_path
      end

      def call
        announce("Running #{script_path}")
      end

    private

      attr_reader :script_path
    end
  end
end
