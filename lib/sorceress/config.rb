require 'yaml'

module Sorceress
  class Config
    BLANK_CONFIG = {
      'dependencies' => {}
    }.freeze

    def initialize(config_file = nil)
      @config_file = config_file
    end

    def dependencies
      dependencies = default_config['dependencies'].map { |dep| [dep, {}] }.to_h
      dependencies.merge(process_dependencies(config['dependencies']))
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
