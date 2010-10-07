require 'adapter/asserts'
require 'adapter/exceptions'

module Adapter
  extend Asserts

  module Defaults
    def fetch(key, value=nil, &block)
      read(key) || begin
        value = yield(key) if value.nil? && block_given?
        write(key, value)
        value
      end
    end

    def key?(key)
      !read(key).nil?
    end

    private
      def key_for(key)
        key.is_a?(String) ? key : Marshal.dump(key)
      end

      def serialize(value)
        Marshal.dump(value)
      end

      def deserialize(value)
        value && Marshal.load(value)
      end
  end

  def self.definitions
    @definitions ||= {}
  end

  def self.define(name, mod=nil, &block)
    definition_module = Module.new
    definition_module.send(:include, Defaults)
    definition_module.send(:include, mod) unless mod.nil?
    definition_module.send(:include, Module.new(&block)) if block_given?
    assert_valid_module(definition_module)
    definitions[name.to_sym] = definition_module
  end

  def self.adapters
    @adapters ||= {}
  end

  def self.[](name)
    assert_valid_adapter(name)
    adapters[name.to_sym] ||= get_adapter_instance(name)
  end

  private
    def self.get_adapter_instance(name)
      Class.new do
        attr_reader :client

        def initialize(client)
          @client = client
        end

        include Adapter.definitions[name.to_sym]

        alias get read
        alias set write

        alias []  read
        alias []= write
      end
    end
end