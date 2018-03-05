require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'semmy'
Semmy::Tasks.install

task default: :spec
