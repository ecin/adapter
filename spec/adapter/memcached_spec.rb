require 'helper'
require 'adapter/memcached'

describe "Memcached adapter" do
  before do
    @client = Memcached.new('localhost:11211', :namespace => 'adapter_spec')
    @adapter = Adapter[:memcached].new(@client)
  end

  it_should_behave_like 'a marshaled adapter'
end