require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require File.expand_path('../lib/adapter/version', __FILE__)

Spec::Rake::SpecTask.new do |t|
  t.ruby_opts << '-rubygems'
  t.verbose = true
end

task :default => :spec

desc 'Builds the gem'
task :build do
  sh "gem build adapter.gemspec"
end

desc 'Builds and installs the gem'
task :install => :build do
  sh "gem install adapter-#{Adapter::Version}"
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
  sh "git tag v#{Adapter::Version}"
  sh "git push origin master"
  sh "git push origin v#{Adapter::Version}"
  sh "gem push adapter-#{Adapter::Version}.gem"
end
