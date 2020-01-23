module Sorceress
  class Incantation
    SEARCH_ROOTS = [Sorceress.root.join('lib/spells')].freeze

    def call
      spells = Sorceress.spellbook.steps.map do |spell|
        find_spell(spell)
      end

      spells.each(&:call)
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

    def find_spell(spell_name)
      name = spell_name(spell_name)

      spell = if (klass = spell_class(name))
        klass.new
      elsif (path = shell_script(spell_name))
        Sorceress::RunScript.new(path)
      end

      raise SpellNotFound, spell_name, "No #{spell_name} spell found" unless spell
      raise InvalidSpell, spell.class unless spell.class < Sorceress::Spell

      spell
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
