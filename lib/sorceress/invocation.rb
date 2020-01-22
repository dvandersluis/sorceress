module Sorceress
  class Invocation
    def call
      Sorceress.spellbook.steps.each do |spell|
        find_spell(spell).call
      end
    end

  private

    def spell_name(name)
      name.to_s.split('_').map(&:capitalize).join
    end

    def find_spell(spell_name)
      name = spell_name(spell_name)

      spell = if Sorceress.const_defined?(name)
        Sorceress.const_get(name).new
      elsif (path = shell_script(spell_name))
        Sorceress::RunScript.new(path)
      end

      raise SpellNotFound, "No #{spell_name} spell found" unless spell
      raise InvalidSpell unless spell.class < Sorceress::Spell

      spell
    end

    def shell_script(spell)
      path = Sorceress.root.join("lib/spells/#{spell}.sh")
      path if File.exist?(path)
    end
  end
end
