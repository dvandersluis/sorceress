unless {}.respond_to?(:except)
  class Hash
    def except(*keys)
      dup.except!(*keys)
    end

    def except!(*keys)
      keys.each { |key| delete(key) }
      self
    end
  end
end
