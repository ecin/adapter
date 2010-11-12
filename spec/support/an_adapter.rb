shared_examples_for "an adapter" do
  it "can read the client" do
    adapter.client.should == client
  end

  AdapterTestTypes.each do |type, (key, key2)|
    it "reads from keys that are #{type}s like a Hash" do
      handle_failed_connections do
        adapter[key].should == nil
      end
    end

    it "writes String values to keys that are #{type}s like a Hash" do
      handle_failed_connections do
        adapter[key] = "value"
        adapter[key].should == "value"
      end
    end

    it "guarantees that a different String value is retrieved from the #{type} key" do
      handle_failed_connections do
        value = "value"
        adapter[key] = value
        adapter[key].should_not be_equal(value)
      end
    end

    it "guarantees that a different Object value is retrieved from the #{type} key" do
      handle_failed_connections do
        value = {:foo => :bar}
        adapter[key] = value
        adapter[key].should_not be_equal(:foo => :bar)
      end
    end

    it "returns false from key? if a #{type} key is not available" do
      handle_failed_connections do
        adapter.key?(key).should be_false
      end
    end

    it "returns true from key? if a #{type} key is available" do
      handle_failed_connections do
        adapter[key] = "value"
        adapter.key?(key).should be_true
      end
    end

    it "removes and return an element with a #{type} key from the backing store via delete if it exists" do
      handle_failed_connections do
        adapter[key] = "value"
        adapter.delete(key).should == "value"
        adapter.key?(key).should be_false
      end
    end

    it "returns nil from delete if an element for a #{type} key does not exist" do
      handle_failed_connections do
        adapter.delete(key).should be_nil
      end
    end

    it "removes all #{type} keys from the store with clear" do
      handle_failed_connections do
        adapter[key] = "value"
        adapter[key2] = "value2"
        adapter.clear
        adapter.key?(key).should_not be_true
        adapter.key?(key2).should_not be_true
      end
    end

    it "fetches a #{type} key with a default value with fetch, if the key is not available" do
      handle_failed_connections do
        adapter.fetch(key, "value").should == "value"
      end
    end

    it "fetches a #{type} key with a block with fetch, if the key is not available" do
      handle_failed_connections do
        adapter.fetch(key) { |k| "value" }.should == "value"
      end
    end

    it "does not run the block if the #{type} key is available" do
      handle_failed_connections do
        adapter[key] = "value"
        unaltered = "unaltered"
        adapter.fetch(key) { unaltered = "altered" }
        unaltered.should == "unaltered"
      end
    end

    it "fetches a #{type} key with a default value with fetch, if the key is available" do
      handle_failed_connections do
        adapter[key] = "value2"
        adapter.fetch(key, "value").should == "value2"
      end
    end

    it "writes #{key} values with #write" do
      handle_failed_connections do
        adapter.write(key, "value")
        adapter[key].should == "value"
      end
    end
  end

  it "refuses to #[] from keys that cannot be marshalled" do
    handle_failed_connections do
      lambda do
        adapter[Struct.new(:foo).new(:bar)]
      end.should raise_error(TypeError)
    end
  end

  it "refuses to fetch from keys that cannot be marshalled" do
    handle_failed_connections do
      lambda do
        adapter.fetch(Struct.new(:foo).new(:bar), true)
      end.should raise_error(TypeError)
    end
  end

  it "refuses to #[]= to keys that cannot be marshalled" do
    handle_failed_connections do
      lambda do
        adapter[Struct.new(:foo).new(:bar)] = "value"
      end.should raise_error(TypeError)
    end
  end

  it "refuses to store to keys that cannot be marshalled" do
    handle_failed_connections do
      lambda do
        adapter.write Struct.new(:foo).new(:bar), "value"
      end.should raise_error(TypeError)
    end
  end

  it "refuses to check for key? if the key cannot be marshalled" do
    handle_failed_connections do
      lambda do
        adapter.key? Struct.new(:foo).new(:bar)
      end.should raise_error(TypeError)
    end
  end

  it "refuses to delete a key if the key cannot be marshalled" do
    handle_failed_connections do
      lambda do
        adapter.delete Struct.new(:foo).new(:bar)
      end.should raise_error(TypeError)
    end
  end

  it "specifies that it is writable via frozen?" do
    handle_failed_connections do
      adapter.should_not be_frozen
    end
  end
end