module Sorceress
  class Spell
    module Find
      SEARCH_ROOTS = [Sorceress.root.join('lib/spells')].freeze

      def find(spell_name, data: nil, shell_args: [], raise: false)
        name = spell_name(spell_name)

        if (klass = spell_class(name))
          return klass.new(data) if klass < Sorceress::Spell
          raise InvalidSpell, klass if raise
        elsif (path = LocateScript.find(spell_name))
          Sorceress::Spells::RunScript.new(path, *Array(shell_args))
        end
      end

      def find!(spell_name, shell_args: [])
        find(spell_name, shell_args: shell_args, raise: true) || raise(SpellNotFound, spell_name)
      end

    private

      def spell_name(name)
        name.to_s.split(%r{(?<=[_/])}).map do |part|
          part.gsub('/', '::').gsub('_', '').capitalize
        end.join
      end

      def spell_class(name)
        Sorceress::Spells.const_get(name)
      rescue NameError
        nil
      end

      def shell_script(spell)
        SEARCH_ROOTS.each do |root|
          Dir.chdir(root) do
            glob = Dir.glob("**/#{spell}.{sh,ksh,bash}")
            return root.join(glob.first) if glob.any?
          end
        end

        nil
      end
    end
  end
end
