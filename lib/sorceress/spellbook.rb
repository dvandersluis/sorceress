require 'yaml'

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
      dependencies = process(default_spellbook['dependencies'])
      dependencies.deep_merge!(process(user_spellbook['dependencies']))
      dependencies.each { |_dep, metadata| metadata.reject! { |_, v| v.nil? || v == 'none' } }
    end

  private

    attr_reader :user_spellbook

    def default_spellbook
      @default_spellbook ||= load_yaml(Sorceress.root.join('config/default.yml'))
    end

    def process(dependencies)
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
