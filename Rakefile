#!/usr/bin/env rake
require 'rspec'
require 'rspec/core/rake_task'

desc "Run all RSpec test examples"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec
