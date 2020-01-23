module Sorceress
  module Spells
    module Core
      class InstallFeatures < Spell
        def call
          announce('Installing Features')
          p(artifacts[:missing_features])
        end
      end
    end
  end
end
