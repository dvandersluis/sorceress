unless [].respond_to?(:to_h)
  # Array#to_h is not defined in Ruby < 2.1
  class Array
    def to_h
      h = {}

      each do |item|
        raise ArgumentError, "element has wrong array length (expected 2, was #{item.size})" unless item.size == 2

        h[item[0]] = item[1]
      end

      h
    end
  end
end
