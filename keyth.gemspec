# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = 'keyth'
  s.version     = '0.1.0'
  s.date        = '2014-08-16'
  s.summary     = 'Keyth!'
  s.description = 'Handles named keys for use in config files'
  s.authors     = ['K M Lawrence']
  s.email       = 'keith@kludge.co'
  s.executables = ['keyth_admin']
  s.files       = ['lib/keyth.rb', 'lib/keyth/yaml.rb', 'lib/keyth/dotenv.rb', 'bin/keyth_admin']
  s.homepage    = 'http://rubygems.org/gems/keyth'
  s.license     = 'MIT'
end
