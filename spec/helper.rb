require 'bundler/setup'
require 'pathname'
require 'logger'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
log_path  = root_path.join('log')
log_path.mkpath

$:.unshift(lib_path)

require 'spec'
require 'adapter'
require 'log_buddy'

logger = Logger.new(log_path.join('test.log'))
LogBuddy.init(:logger => logger)

module ModuleHelpers
  def valid_module
    Module.new do
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
end

Spec::Runner.configure do |config|
  config.include(ModuleHelpers)

  config.before(:each) do
    Adapter.adapters.clear
    Adapter.definitions.clear
  end
end