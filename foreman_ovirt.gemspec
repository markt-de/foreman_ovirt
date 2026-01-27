require File.expand_path('lib/foreman_ovirt/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_ovirt'
  s.version     = ForemanOvirt::VERSION
  s.metadata    = { 'is_foreman_plugin' => 'true' }
  s.license     = 'GPL-3.0'
  s.authors     = ['markt.de']
  s.email       = ['github-oss-noreply@markt.de']
  s.homepage    = 'https://github.com/markt-de/foreman_ovirt'
  s.summary     = 'oVirt as a compute resource for The Foreman'
  # also update locale/gemspec.rb
  s.description = 'The ForemanOvirt plugin adds oVirt compute resource to Foreman using fog-ovirt. It is compatible with Foreman 3.16+'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json']
  s.test_files = Dir['test/**/*'] + Dir['webpack/**/__tests__/*.js']

  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'fog-ovirt', '>= 2.0.3'
  s.add_dependency 'ovirt-engine-sdk', '>= 4.6.0'

  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'theforeman-rubocop', '~> 0.1'
end
