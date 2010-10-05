require 'helper'

describe Adapter do
  describe ".definitions" do
    it "defaults to empty hash" do
      Adapter.definitions.should == {}
    end
  end

  describe ".define" do
    before do
      @mod = valid_module
    end
    let(:mod) { @mod }

    it "adds adapter to definitions" do
      Adapter.define(:nothing, mod)
      Adapter.definitions[:nothing].should == @mod
    end

    it "symbolizes string adapter names" do
      Adapter.define('nothing', mod)
      Adapter.definitions.keys.should include(:nothing)
    end

    [:get, :set, :delete, :clear].each do |method_name|
      it "raises error if #{method_name} is not defined in module" do
        mod.send(:undef_method, method_name)

        lambda do
          Adapter.define(:nothing, mod)
        end.should raise_error(Adapter::IncompleteAPI, "Missing methods needed to complete API (#{method_name})")
      end
    end
  end

  describe ".[]" do
    before do
      Adapter.define(:hash, valid_module)
    end

    it "returns adapter instance" do
      adapter = Adapter[:hash].new({})
      adapter.set('foo', 'bar')
      adapter.get('foo').should == 'bar'
      adapter.delete('foo')
      adapter.get('foo').should be_nil

      adapter.set('foo', 'bar')
      adapter.clear
      adapter.get('foo').should be_nil
    end

    it "raises error for undefined adapter" do
      lambda do
        Adapter[:non_existant]
      end.should raise_error(Adapter::Undefined)
    end

    it "memoizes adapter by name" do
      Adapter[:hash].should equal(Adapter[:hash])
    end
  end
end