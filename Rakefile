require 'bundler'
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = "--colour --format d"
end

task :test => :spec
