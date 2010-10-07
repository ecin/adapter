require 'helper'

describe Adapter do
  describe ".definitions" do
    it "defaults to empty hash" do
      Adapter.definitions.should == {}
    end
  end

  describe ".define with string name" do

  end

  describe ".define with module" do
    describe "with string name" do
      it "symbolizes string adapter names" do
        Adapter.define('memory', valid_module)
        Adapter.definitions.keys.should include(:memory)
      end
    end

    describe "with module" do
      before do
        @mod = valid_module
        Adapter.define(:memory, mod)
      end
      let(:mod) { @mod }

      it "adds adapter to definitions" do
        Adapter.definitions.should have_key(:memory)
        Adapter.definitions[:memory].should be_instance_of(Module)
      end

      [:get, :set, :delete, :clear].each do |method_name|
        it "raises error if #{method_name} is not defined in module" do
          mod.send(:undef_method, method_name)

          lambda do
            Adapter.define(:memory, mod)
          end.should raise_error(Adapter::IncompleteAPI, "Missing methods needed to complete API (#{method_name})")
        end
      end
    end

    describe "with block" do
      before do
        Adapter.define(:memory) do
          def get(key)
            client[key]
          end

          def set(key, value)
            client[key] = value
          end

          def delete(key)
            client.delete(key)
          end

          def clear
            client.clear
          end
        end
      end

      it "adds adapter to definitions" do
        Adapter.definitions.should have_key(:memory)
      end

      it "modularizes the block" do
        Adapter.definitions[:memory].should be_instance_of(Module)
      end
    end

    describe "with module and block" do
      before do
        Adapter.define(:memory, valid_module) do
          def clear
            raise 'Not Implemented'
          end
        end
      end

      it "includes block after module" do
        adapter = Adapter[:memory].new({})
        adapter.set('foo', 'bar')
        adapter.get('foo').should == 'bar'
        lambda do
          adapter.clear
        end.should raise_error('Not Implemented')
      end
    end
  end

  describe ".[]" do
    before do
      Adapter.define(:memory, valid_module)
    end

    it "returns adapter instance" do
      adapter = Adapter[:memory].new({})
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
      Adapter[:memory].should equal(Adapter[:memory])
    end
  end
end