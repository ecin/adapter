require 'adapter'
require 'redis'

Adapter.define(:redis) do
  def read(key)
    deserialize(client.get(key_for(key)))
  end

  def write(key, value)
    client.set(key_for(key), serialize(value))
  end

  def delete(key)
    read(key).tap { client.del(key_for(key)) }
  end

  def clear
    client.flushdb
  end
end