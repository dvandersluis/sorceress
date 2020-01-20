require 'yaml'

module Sorceress
  class Spellbook
    # A spellbook is a set of instructions that sorceress uses to setup a new environment

    EMPTY_SPELLBOOK = {
      'dependencies' => {}
    }.freeze

    def initialize(file = nil)
      @file = file
    end

    def dependencies
      dependencies = default_spellbook['dependencies'].map { |dep| [dep, {}] }.to_h
      dependencies.merge(process_dependencies(user_spellbook['dependencies']))
    end

  private

    attr_reader :file

    def default_spellbook
      @default_spellbook ||= load_yaml(Sorceress.root.join('config/default.yml'))
    end

    def user_spellbook
      return EMPTY_SPELLBOOK unless file

      @user_spellbook ||= load_yaml(file)
    end

    def process_dependencies(dependencies)
      if dependencies.is_a?(Array)
        process_array(dependencies)
      elsif dependencies.is_a?(Hash)
        dependencies.map { |key, val| [key, val.nil? ? {} : val] }.to_h
      end
    end

    def process_array(dependencies) # rubocop:disable Metrics/MethodLength
      dependencies.map! do |dep|
        if dep.is_a?(Hash)
          if dep.length > 1 && dep.first[1].nil?
            key = dep.first[0]
            dep.delete(key)

            { key => dep }
          else
            dep
          end
        else
          { dep => {} }
        end
      end

      dependencies.inject({}, &:merge)
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
