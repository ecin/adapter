require 'adapter'

Adapter.define(:memory) do
  def read(key)
    deserialize(client[key_for(key)])
  end

  def write(key, value)
    client[key_for(key)] = serialize(value)
  end

  def delete(key)
    read(key).tap { client.delete(key_for(key)) }
  end

  def clear
    client.clear
  end
end