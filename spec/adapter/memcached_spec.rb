require 'helper'
require 'adapter/memcached'

describe "Memcached adapter" do
  before do
    memcache = Memcached.new('localhost:11211', :namespace => 'moneta_spec')
    @adapter = Adapter[:memcached].new(memcache)
    @adapter.clear
  end
  let(:adapter) { @adapter }

  it_should_behave_like 'a marshaled adapter'
end