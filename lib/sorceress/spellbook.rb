require 'yaml'
require 'sorceress/spellbook/dependencies'

module Sorceress
  class Spellbook
    # A spellbook is a set of instructions that sorceress uses to setup a new environment

    EMPTY_SPELLBOOK = {
      'dependencies' => {}
    }.freeze

    def initialize(hash_or_file = nil)
      @user_spellbook = case hash_or_file
        when nil
          EMPTY_SPELLBOOK

        when Hash
          hash_or_file

        else
          load_yaml(hash_or_file)
      end
    end

    def dependencies
      Dependencies.new(default_spellbook, user_spellbook).extract
    end

  private

    attr_reader :user_spellbook

    def default_spellbook
      @default_spellbook ||= load_yaml(Sorceress.root.join('config/default.yml'))
    end

    def load_yaml(path)
      if YAML.respond_to?(:safe_load)
        YAML.safe_load(File.read(path))
      else
        # Ruby < 2.1 doesn't define YAML.safe_load
        YAML.load_file(path)
      end
    end
  end
end
