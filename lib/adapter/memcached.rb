require 'adapter'
require 'memcached'

Adapter.define(:memcached) do
  def read(key)
    deserialize(client.get(key_for(key)))
  rescue Memcached::NotFound
  end

  def write(key, value)
    client.set(key_for(key), serialize(value))
  end

  def delete(key)
    read(key).tap { client.delete(key_for(key)) }
  rescue Memcached::NotFound
  end

  def clear
    client.flush
  end

  private
    def key_for(key)
      [super].pack("m").strip
    end
end