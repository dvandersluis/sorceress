module Sorceress
  class FindDependencies < Spell
    def call
      announce('Determining Dependencies')

      spellbook.dependencies.each do |name, data|
        printf "#{name}... "
        dep = Dependency.for(name, data)
        result(dep) || artifacts[:missing_features] << dep
      end
    end

  private

    def dependency_wrong_version?(dep)
      dep.executable && !dep.requirement_met?
    end

    def result(dep)
      if dep.requirement_met?
        puts '✅'
        return true
      end

      puts not_found_message(dep)

      false
    end

    def not_found_message(dep)
      if dep.executable
        msg = color("(#{dep.requirements.join(', ')} requested; #{dep.local_version} found)", Colors::YELLOW)
        "⚠️  #{msg}"
      else
        '❌'
      end
    end
  end
end
