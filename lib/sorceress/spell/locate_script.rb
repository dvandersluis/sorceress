module Sorceress
  class Spell
    module LocateScript
      SEARCH_ROOTS = [Sorceress.root.join('lib/spells')].freeze

      def self.find(name)
        return name if File.exist?(name) || !`which #{name}`.empty?

        SEARCH_ROOTS.each do |root|
          Dir.chdir(root) do
            glob = Dir.glob("**/#{name}.{sh,ksh,bash}")
            return root.join(glob.first) if glob.any?
          end
        end

        nil
      end
    end
  end
end
