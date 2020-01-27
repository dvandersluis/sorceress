module Sorceress
  class Spellbook
    class MergeDependencies
      class << self
        def call(book1, book2)
          book = process(book1).deep_merge(process(book2))

          book.each do |_dep, metadata|
            metadata.reject! { |_, v| v.nil? || v == 'none' }
          end

          book
        end

      private

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
end
