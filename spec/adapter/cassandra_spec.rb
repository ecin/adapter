require 'helper'
require 'adapter/cassandra'

describe "Cassandra adapter" do
  before do
    handle_failed_connections do
      @client = Cassandra.new("Keyspace1")
      @adapter = Adapter[:cassandra].new(@client, :column_family => 'Standard2')
      @adapter.clear
    end
  end

  let(:adapter) { @adapter }
  let(:client)  { @client }

  it_should_behave_like 'a marshaled adapter'
end