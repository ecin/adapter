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

Spec::Runner.configure do |config|
  config.before(:each) do

  end
end