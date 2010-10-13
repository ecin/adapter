require 'adapter'
require 'redis'

Adapter.define(:redis) do
  def read(key)
    decode(client.get(key_for(key)))
  end

  def write(key, value)
    client.set(key_for(key), encode(value))
  end

  def delete(key)
    read(key).tap { client.del(key_for(key)) }
  end

  def clear
    client.flushdb
  end
end