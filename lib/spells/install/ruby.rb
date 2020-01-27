module Sorceress
  module Spells
    module Install
      class Ruby < Spell
        def call
          announce("Installing ruby v#{version}")
        end

      private

        def version
          data.install_version
        end
      end
    end
  end
end
