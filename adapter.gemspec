# encoding: UTF-8
require File.expand_path('../lib/adapter/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'adapter'
  s.homepage     = 'http://github.com/newtoy/adapter'
  s.summary      = 'A simple interface to anything'
  s.require_path = 'lib'
  s.authors      = ['John Nunemaker']
  s.email        = ['nunemaker@gmail.com']
  s.version      = Adapter::Version
  s.platform     = Gem::Platform::RUBY
  s.files        = Dir.glob("{lib,spec}/**/*") + %w[LICENSE Rakefile README.rdoc]

  s.add_development_dependency 'rspec', '~> 1.3.0'
  s.add_development_dependency 'log_buddy'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'memcached'
  s.add_development_dependency 'redis'
  s.add_development_dependency 'cassandra'
  s.add_development_dependency 'SystemTimer'
  s.add_development_dependency 'riak-client', '~> 0.8'
  s.add_development_dependency 'curb'
  s.add_development_dependency 'activesupport', '~> 3'
end