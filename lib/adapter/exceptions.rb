module Adapter
  class Error < StandardError; end

  class Undefined < Error; end

  class IncompleteAPI < Error
    def initialize(methods)
      super("Missing methods needed to complete API (#{methods.join(', ')})")
    end
  end
end