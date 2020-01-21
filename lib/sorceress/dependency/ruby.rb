module Sorceress
  class Dependency
    class Ruby < Dependency
      def initialize(data)
        super('ruby', data)
      end

      def managers
        data.dig('dependencies', 'manager') || {}
      end

      def manager_to_install
        data.fetch('manager', managers.first)
      end
    end
  end
end
