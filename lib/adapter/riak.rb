require 'adapter'
require 'riak'

module Adapter
  module Riak
    class Conflict < StandardError
      attr_reader :robject

      def initialize(robject)
        @robject = robject
        super('Read conflict present')
      end
    end

    # Optimize key? to do head request in riak instead of full key read and nil check
    def key?(key)
      client.exists?(key_for(key))
    end

    def read(key)
      robject = client.get(key_for(key))
      raise Conflict.new(robject) if robject.conflict?
      robject.data
    rescue ::Riak::FailedRequest => e
      e.code.to_i == 404 ? nil : raise(e)
    end

    def write(key, value)
      key = key_for(key)
      obj = client.get_or_new(key)
      obj.content_type = 'application/json'
      obj.data = value
      obj.store
      value
    end

    def delete(key)
      read(key).tap { client.delete(key_for(key)) }
    end

    def clear
      client.keys do |keys|
        keys.each { |key| client.delete(key) }
      end
    end

    private
      def serialize(value)
        value
      end

      def deserialize(value)
        value
      end
  end
end

Adapter.define(:riak, Adapter::Riak)