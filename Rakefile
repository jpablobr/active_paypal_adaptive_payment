require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

desc "Default Task"
task :default => :test

Rake::TestTask.new

YARD::Rake::YardocTask.new do |t|
  t.options += ['--verbose', '--title', "Active Paypal Adaptive Payment Documentation"]
end
