require 'yaml'
require 'sorceress/spellbook/merge_dependencies'

module Sorceress
  class Spellbook
    # A spellbook is a set of instructions that sorceress uses to setup a new environment

    EMPTY_SPELLBOOK = {
      'dependencies' => {},
      'steps' => {}
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
      @dependencies ||= spellbook['dependencies']
    end

    def steps
      @steps ||= begin
        spellbook['prerequisites'].concat(Array(spellbook['steps']))
      end
    end

  private

    attr_reader :user_spellbook

    def default_spellbook
      @default_spellbook ||= load_yaml(Sorceress.root.join('config/default.yml'))
    end

    def spellbook
      @spellbook ||= default_spellbook.merge(user_spellbook) do |key, default, user|
        if key == 'dependencies'
          MergeDependencies.call(default, user)
        elsif key == 'prerequisites'
          # user spellbooks are not allowed to define prerequisites
          default
        else
          user
        end
      end
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
