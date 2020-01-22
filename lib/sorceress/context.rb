require 'singleton'

module Sorceress
  class Context
    include Singleton

    def spellbook
      @spellbook ||= Spellbook.new(spellbook_path)
    end

    def artifacts
      @artifacts ||= {
        missing_features: []
      }
    end

  private

    def spellbook_path
      return @spellbook_path if defined?(@spellbook_path)

      @spellbook_path = %w(.sorceress.yml config/sorceress.yml).detect do |path|
        path = Sorceress.root.join(path)
        File.exist?(path)
      end
    end
  end
end
