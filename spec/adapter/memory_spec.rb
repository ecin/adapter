require 'helper'
require 'adapter/memory'

describe "Memory adapter" do
  before do
    @client = {}
    @adapter = Adapter[:memory].new(@client)
    @adapter.clear
  end

  let(:adapter) { @adapter }
  let(:client)  { @client }

  it_should_behave_like 'a marshaled adapter'
end