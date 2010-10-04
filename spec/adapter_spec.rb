require 'helper'

describe Adapter do
  describe ".adapters" do
    it "defaults to empty hash" do
      Adapter.s.should == {}
    end
  end

  describe ".define" do
    before do
      @mod = Module.new do
        def get(key);         end
        def set(key, value);  end
        def delete(key);      end
        def clear;            end
      end

      Adapter.define(:nothing, @mod)
    end

    it "keeps track of adapter" do
      Adapter.s.keys.should include(:nothing)
      Adapter.s[:nothing].should == @mod
    end

    it "raises error if get is not defined" do
      mod = Module.new do
        def set(key, value);  end
        def delete(key);      end
        def clear;            end
      end

      lambda do
        Adapter.define(:nothing, mod)
      end.should raise_error(Adapter::IncompleteAPIError, 'Missing methods needed to complete API (get)')
    end

    it "raises error if set is not defined" do
      mod = Module.new do
        def get(key);         end
        def delete(key);      end
        def clear;            end
      end

      lambda do
        Adapter.define(:nothing, mod)
      end.should raise_error(Adapter::IncompleteAPIError, 'Missing methods needed to complete API (set)')
    end

    it "raises error if delete is not defined" do
      mod = Module.new do
        def get(key);         end
        def set(key, value);  end
        def clear;            end
      end

      lambda do
        Adapter.define(:nothing, mod)
      end.should raise_error(Adapter::IncompleteAPIError, 'Missing methods needed to complete API (delete)')
    end

    it "raises error if clear is not defined" do
      mod = Module.new do
        def get(key);         end
        def set(key, value);  end
        def delete(key);      end
      end

      lambda do
        Adapter.define(:nothing, mod)
      end.should raise_error(Adapter::IncompleteAPIError, 'Missing methods needed to complete API (clear)')
    end
  end
end