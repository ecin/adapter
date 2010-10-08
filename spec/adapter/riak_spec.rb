require 'helper'
require 'adapter/riak'

describe "Riak adapter" do
  before do
    @client = Riak::Client.new['adapter_spec']
    @adapter = Adapter[:riak].new(@client)
  end

  it_should_behave_like 'a json adapter'
end