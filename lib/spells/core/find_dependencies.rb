module Sorceress
  module Spells
    module Core
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

        def skip_check?
          !spellbook.fetch('check_dependencies', true)
        end

        def result(dep)
          if skip_check?
            puts '❌'
            return false
          elsif dep.requirement_met?
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
  end
end
