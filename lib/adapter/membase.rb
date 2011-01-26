require 'adapter/memcached'

Adapter.define(:membase, Adapter::Memcached) do
  def key_for(key)
    key
  end
end