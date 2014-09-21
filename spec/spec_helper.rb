# encoding: utf-8
require 'fileutils'
require 'tmpdir'
require_relative '../lib/keyth'

TESTING_NAMESPACE = 'rspec_testing_only'

def make_temp_store
  Keyth.namespace(TESTING_NAMESPACE)
  @dir = Dir.mktmpdir
  ENV['KEYTH_KEYFILE'] = File.join(@dir, TESTING_NAMESPACE + '.yml')
end

def destroy_temp_store
  File.unlink(ENV['KEYTH_KEYFILE']) if File.file?(ENV['KEYTH_KEYFILE'])
  FileUtils.remove_entry_secure @dir
end
