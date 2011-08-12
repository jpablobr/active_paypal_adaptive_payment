require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

gemspec = eval(File.read('active_paypal_adaptive_payment.gemspec'))

desc "Default Task"
task :default => 'test'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/*.rb'
  test.verbose = true
end

desc "Builds the gem"
task :gem do
  Gem::Builder.new(eval(File.read('active_paypal_adaptive_payment.gemspec'))).build
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'readme.md', 'CHANGELOG', 'MIT-LICENSE']
  t.options += ['--any', '--extra', '--opts']
  t.options += ['--verbose', '--title', "Active Paypal Adaptive Payment Documentation"]
end
