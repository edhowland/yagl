module Yagl
  class BinaryOption < Option
    alias_method :parent_to_a, :to_a
    def binary?; true; end
    def to_a
      antioption = Option.new("no-#{long}", false)
      return [parent_to_a, antioption.to_a]
    end
    def usage_options
      options = parent_to_a[0..-2]
      options[0] = "--[no-]#{long}"
      options.reverse.join(', ')
    end
  end
end