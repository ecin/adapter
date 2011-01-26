module ModuleHelpers
  def valid_module
    Module.new do
      def read(key)
        decode(client[key_for(key)])
      end

      def write(key, value)
        client[key_for(key)] = encode(value)
      end

      def delete(key)
        client.delete(key_for(key))
      end

      def clear
        client.clear
      end
    end
  end

  def handle_failed_connections
    yield
  rescue => e
    puts e.inspect
    puts e.message unless e.message.nil?
    pending
  end
end