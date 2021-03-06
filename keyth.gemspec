# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = 'keyth'
  s.version     = '0.3.2'
  s.date        = '2014-09-21'
  s.summary     = 'Keyth!'
  s.description = 'Handles named keys for use in config files'
  s.authors     = ['K M Lawrence']
  s.email       = 'keith@kludge.co.uk'
  s.executables = ['keyth_admin', 'keyth_check_file']
  s.files       = ['lib/keyth.rb', 'lib/keyth/yaml.rb', 'lib/keyth/dotenv.rb',
                   'bin/keyth_admin', 'bin/keyth_check_file']
  s.homepage    = 'http://rubygems.org/gems/keyth'
  s.license     = 'MIT'

  s.add_development_dependency 'dotenv'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
