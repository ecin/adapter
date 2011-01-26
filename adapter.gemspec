# encoding: UTF-8
require File.expand_path('../lib/adapter/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'adapter'
  s.homepage     = 'http://github.com/newtoy/adapter'
  s.summary      = 'A simple interface to anything'
  s.require_path = 'lib'
  s.authors      = ['John Nunemaker']
  s.email        = ['nunemaker@gmail.com']
  s.version      = Adapter::VERSION
  s.platform     = Gem::Platform::RUBY
  s.files        = Dir.glob("{lib,spec}/**/*") + %w[LICENSE Rakefile README.rdoc]
end