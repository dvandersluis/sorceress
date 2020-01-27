module Sorceress
  module Spells
    module Core
      class InstallFeatures < Spell
        def call
          features.each do |feature|
            spell = spell_for(feature)
            spell.call if spell.respond_to?(:call)
          end
        end

      private

        def features
          artifacts[:missing_features]
        end

        def spell_for(feature)
          find_spell(feature) || default_spell(feature)
        end

        def find_spell(feature)
          Spell.find("install/#{feature.name}", data: feature, shell_args: [feature.install_version])
        end

        def default_spell(feature)
          RunScript.new('core/install', feature.name, feature.install_version)
        end
      end
    end
  end
end
