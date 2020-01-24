module Sorceress
  module Spells
    class RunScript < Spell
      attr_reader :script_path, :arguments

      def initialize(script_path, *arguments)
        @script_path = LocateScript.find(script_path)
        @arguments = arguments
      end

      def call
        message = "Running #{script_path}"
        message << " with arguments #{arguments.join(' ')}" if arguments.any?
        announce(message)
      end
    end
  end
end
