module Adapter
  class IncompleteAPIError < StandardError
    def initialize(methods)
      super("Missing methods needed to complete API (#{methods.join(', ')})")
    end
  end

  RequiredMethods = [:get, :set, :delete, :clear]

  def self.s
    @adapters ||= {}
  end

  def self.define(name, mod)
    assert_valid_module(mod)
    s[name.to_sym] = mod
  end

  private
    def self.assert_valid_module(mod)
      assert_methods_defined(mod)
    end

    def self.assert_methods_defined(mod)
      missing_methods = []
      RequiredMethods.each do |meth|
        missing_methods << meth unless mod.method_defined?(meth)
      end
      raise IncompleteAPIError.new(missing_methods) unless missing_methods.empty?
    end
end