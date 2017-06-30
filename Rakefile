require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/testtask'

directory 'tests'

RSpec::Core::RakeTask.new(:spec)

Rake::TestTask.new do |t|
  t.libs << "tests"
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
end


