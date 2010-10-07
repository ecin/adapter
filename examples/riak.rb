require 'rubygems'
require 'riak'
require 'pathname'

root_path   = Pathname(__FILE__).dirname.join('..').expand_path
lib_path    = root_path.join('lib')
$:.unshift(lib_path)

require 'adapter'

module RiakAdapter
  class Conflict < StandardError
    attr_reader :robject

    def initialize(robject)
      @robject = robject
      super('Read conflict present')
    end
  end

  def key?(key)
    client.exists?(key_for(key))
  end

  def read(key)
    robject = client.get(key_for(key))
    raise Conflict.new(robject) if robject.conflict?
    robject.data
  rescue Riak::FailedRequest => e
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
    client.delete(key_for(key))
  end

  def clear
    client.keys.each { |key| client.delete(key) }
  end
end

Adapter.define(:riak, RiakAdapter)

client  = Riak::Client.new['adapter_example']
adapter = Adapter[:riak].new(client)
adapter.clear

adapter.write('foo', 'bar')
puts 'Should be bar: ' + adapter.read('foo').inspect

adapter.delete('foo')
puts 'Should be nil: ' + adapter.read('foo').inspect

adapter.write('foo', 'bar')
adapter.clear
puts 'Should be nil: ' + adapter.read('foo').inspect

puts 'Should be bar: ' + adapter.fetch('foo', 'bar')
puts 'Should be bar: ' + adapter.read('foo')