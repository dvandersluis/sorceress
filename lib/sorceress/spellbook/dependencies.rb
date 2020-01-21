module Sorceress
  class Spellbook
    class Dependencies
      def initialize(default_spellbook, user_spellbook)
        @default_spellbook = process(default_spellbook['dependencies'])
        @user_spellbook = process(user_spellbook['dependencies'])
      end

      def extract
        book = default_spellbook.deep_merge(user_spellbook)

        book.each do |_dep, metadata|
          metadata.reject! { |_, v| v.nil? || v == 'none' }
        end

        book
      end

    private

      attr_reader :default_spellbook, :user_spellbook

      def process(dependencies)
        return {} if dependencies.nil?

        if dependencies.is_a?(Array)
          rewrite_array(dependencies)
        elsif dependencies.is_a?(Hash)
          dependencies.map { |key, val| [key, val.nil? ? {} : val] }.to_h
        end
      end

      def rewrite_array(dependencies) # rubocop:disable Metrics/MethodLength
        dependencies.map! do |dep|
          if dep.is_a?(Hash)
            if dep.length > 1 && dep.first[1].nil?
              key = dep.first[0]
              { key => dep.except(key) }
            else
              dep
            end
          else
            { dep => {} }
          end
        end

        dependencies.inject({}, &:merge)
      end
    end
  end
end
