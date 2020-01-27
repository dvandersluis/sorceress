module Sorceress
  module Spells
    class RunScript < Spell
      attr_reader :script_path, :arguments

      def initialize(script_path, *arguments)
        @script_path = LocateScript.find(script_path)
        @arguments = arguments.compact
      end

      def call
        system(script_path.to_s, *arguments, exception: true)
      end
    end
  end
end
