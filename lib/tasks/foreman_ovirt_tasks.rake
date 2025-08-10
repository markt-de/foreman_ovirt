require 'rake/testtask'

# Tasks
namespace :foreman_ovirt do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanOvirt'
  Rake::TestTask.new(:foreman_ovirt) do |t|
    test_dir = File.expand_path('../../test', __dir__)
    t.libs << 'test'
    t.libs << test_dir
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

Rake::Task[:test].enhance ['test:foreman_ovirt']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_ovirt', 'foreman_ovirt:rubocop']
end
