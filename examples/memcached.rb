require 'rubygems'
require 'memcached'
require 'pathname'

root_path   = Pathname(__FILE__).dirname.join('..').expand_path
lib_path    = root_path.join('lib')
$:.unshift(lib_path)

require 'adapter'

Adapter.define(:memcached) do
  def read(key)
    deserialize(client.get(key_for(key)))
  rescue Memcached::NotFound
  end

  def write(key, value)
    client.set(key_for(key), serialize(value))
  end

  def delete(key)
    client.delete(key_for(key))
  end

  def clear
    client.flush
  end
end

client  = Memcached.new('localhost:11211', :namespace => 'adapter_example')
adapter = Adapter[:memcached].new(client)
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