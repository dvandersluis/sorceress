require 'yaml'

module Sorceress
  class Config
    BLANK_CONFIG = {
      dependencies: {}
    }.freeze

    def initialize(config_file = nil)
      @config_file = config_file
    end

    def dependencies
      dependencies = default_config[:dependencies].map { |dep| [dep.to_sym, {}] }.to_h
      dependencies.merge(process_dependencies(config[:dependencies]))
    end

  private

    attr_reader :config_file

    def default_config
      @default_config ||= load_yaml(Sorceress.root.join('config/default.yml'))
    end

    def config
      return BLANK_CONFIG unless config_file

      @config ||= load_yaml(config_file)
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
          { dep.to_sym => {} }
        end
      end

      dependencies.inject({}, &:merge)
    end

    def load_yaml(path)
      YAML.safe_load(File.read(path), symbolize_names: true)
    end
  end
end
