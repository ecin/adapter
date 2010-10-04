# encoding: UTF-8
require File.expand_path('../lib/adapter/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'adapter'
  s.homepage     = 'http://github.com/jnunemaker/adapter'
  s.summary      = 'Easily adapt a client to a simple interface.'
  s.require_path = 'lib'
  s.authors      = ['John Nunemaker']
  s.email        = ['nunemaker@gmail.com']
  s.version      = Adapter::Version
  s.platform     = Gem::Platform::RUBY
  s.files        = Dir.glob("{lib,spec}/**/*") + %w[LICENSE Rakefile README.rdoc]

  s.add_development_dependency 'rspec', '~> 1.3.0'
  s.add_development_dependency 'log_buddy'
end