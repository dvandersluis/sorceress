module Sorceress
  module Spells
    class RunScript < Spell
      attr_reader :script_path, :arguments

      def initialize(script_path, *arguments)
        @script_path = LocateScript.find(script_path)
        @arguments = arguments.compact
      end

      def call
        system(script_path.to_s, *arguments)
      end

    private

      def system(script, *args, **kwargs)
        kwargs[:err] = File::NULL unless Sorceress.debug_mode?
        kwargs[:exception] = true if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.6')

        result = super(script, *args, **kwargs)
        raise("Command failed with exit #{$CHILD_STATUS.exitstatus} - #{File.basename(script_path)}") unless result
      end
    end
  end
end
