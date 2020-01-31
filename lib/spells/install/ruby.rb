module Sorceress
  module Spells
    module Install
      class Ruby < Spells::RunScript
        def initialize(data)
          @data = data
          @script_path = LocateScript.find('install/ruby')
          @arguments = [version, managers.join("\t")]
        end

      private

        attr_reader :data

        def version
          data.install_version
        end

        def managers
          data['dependencies']['manager']
        end
      end
    end
  end
end
