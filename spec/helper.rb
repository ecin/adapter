$:.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'bundler'

Bundler.require(:default, :development)

require 'pathname'
require 'logger'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')
log_path  = root_path.join('log')
log_path.mkpath

require 'support/an_adapter'
require 'support/marshal_adapter'
require 'support/json_adapter'
require 'support/module_helpers'

logger = Logger.new(log_path.join('test.log'))
LogBuddy.init(:logger => logger)

Rspec.configure do |c|
  c.include(ModuleHelpers)
end

AdapterTestTypes = {"String" => ["key", "key2"]}