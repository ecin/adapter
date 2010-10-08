module Adapter
  module Defaults
    def fetch(key, value=nil, &block)
      read(key) || begin
        value = yield(key) if value.nil? && block_given?
        write(key, value)
        value
      end
    end

    def key?(key)
      !read(key).nil?
    end

    private
      def key_for(key)
        key.is_a?(String) ? key : Marshal.dump(key)
      end

      def serialize(value)
        Marshal.dump(value)
      end

      def deserialize(value)
        value && Marshal.load(value)
      end
  end
end