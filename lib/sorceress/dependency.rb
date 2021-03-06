require 'forwardable'

module Sorceress
  class Dependency
    VERSION_REGEX = /[0-9]+(?>\.[0-9]+)*/.freeze
    ANCHORED_VERSION_REGEX = /\A#{VERSION_REGEX}\z/.freeze

    extend Forwardable
    def_delegator :data, :[]

    attr_reader :dependency, :requirements, :data
    alias_method :name, :dependency

    def self.for(dependency, data)
      return Ruby.new(data) if dependency == 'ruby'

      new(dependency, data)
    end

    def initialize(dependency, data)
      @dependency = dependency
      @requirements = Array(data.delete('version'))
      @data = data
    end

    def executable
      @executable ||= begin
        path = which.chomp
        path == '' ? nil : path
      end
    end

    def local_version
      return nil unless executable

      @local_version ||= parse_version(find_version)
    end

    def install_version
      return nil unless requirements.any?

      version = requirements.first.dup.gsub(/~>|>=|<=|=/, '').strip
      raise ArgumentError, "cannot determine install_version from #{requirements.join(', ')}" unless version =~ ANCHORED_VERSION_REGEX

      version
    end

    def requirement_met?
      return false unless executable

      Gem::Dependency.new('', requirements).match?('', local_version)
    end

  private

    def parse_version(str)
      match = VERSION_REGEX.match(str)
      match ? match[0] : nil
    end

    def which
      `which #{dependency}`
    end

    def find_version
      `#{executable} --version 2>/dev/null`
    end
  end
end
