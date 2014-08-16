# encoding: utf-8
require_relative '../lib/keyth'

def make_temp_store
  Keyth.namespace('rspec_testing_only')
end

def destroy_temp_store
  key_file = File.join(Dir.home, '.keyth', 'rspec_testing_only.yml')
  File.unlink(key_file) if File.file?(key_file)
end
