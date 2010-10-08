require 'helper'
require 'adapter/redis'

describe "Redis adapter" do
  before do
    @client = Redis.new
    @adapter = Adapter[:redis].new(@client)
  end

  it_should_behave_like 'a marshaled adapter'
end