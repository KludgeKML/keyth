# encoding: utf-8
require 'yaml'
require 'keyth/yaml'
require 'keyth/dotenv'

# Keyhandling module with various functions for keeping keys
# out of configuration files.
module Keyth
  # Retrieves a key from the store, raising errors if the key is missing
  # Params:
  # +key+:: name of the key (without the keyth: prefix)
  def self.get_key(key)
    load_keyfile unless @key_list
    application, key_name = key.split('/')
    fail "Application not found: #{application}!" unless @key_list[application]
    fail "Key not found: #{key}!" unless @key_list[application][key_name]
    @key_list[application][key_name]
  end

  # Retrieves a key from the store, returning nil if the key is missing
  # Params:
  # +key+:: name of the key (without the keyth: prefix)
  def self.get_key_safe(key)
    get_key(key) rescue nil
  end

  # Adds a key to the store
  # Params:
  # +key+:: name of the key (without the keyth: prefix)
  # +value+:: the key value
  def self.add_key(key, value)
    load_keyfile unless @key_list
    application, key_name = key.split('/')
    @key_list[application] = {} unless @key_list.key?(application)
    @key_list[application][key_name] = value
    save_keyfile
  end

  # Removes a key from the store
  # Params:
  # +key+:: name of the key (without the keyth: prefix)
  def self.delete_key(key)
    load_keyfile unless @key_list
    application, key_name = key.split('/')
    @key_list[application].delete(key_name)
    @key_list.delete(application) if @key_list[application].empty?
    save_keyfile
  end

  # Gets a list of keys in the store
  # Params:
  # +application+:: if not nil, only return keys where the part of the key before the slash matches.
  def self.keys(application = nil)
    load_keyfile unless @key_list
    keys = {}
    @key_list.each do |k1, v|
      v.each do |k2, v2|
        keys[k1 + '/' + k2] = v2 if k1 == application || application.nil?
      end
    end
    keys
  end

  # Reads a YAML file, automatically retrieving keys for any value prefixed with "keyth:"
  # Params:
  # +file+:: file object containing YAML to read
  def self.load_yaml(file)
    load_keyfile unless @key_list
    keys = YAML.pre_keyth_load(file)
    fetch_keys(keys)
  end

  # Fixes a string, array-alike, or hash-alike by automatically retrieving keys for any value prefixed with "keyth:"
  # Params:
  # +obj+:: the object to fix
  def self.fetch_keys(obj)
    load_keyfile unless @key_list
    case
    when obj.respond_to?(:keys)
      obj.each do |k, v|
        obj[k] = fetch_keys(v)
      end
    when obj.respond_to?(:each)
      obj.each_with_index do |v, i|
        obj[i] = fetch_keys(v)
      end
    when obj.is_a?(String)
      obj = obj.gsub(/^keyth\:(.*)/) { get_key_safe(Regexp.last_match[1]) || "Missing Key: [#{obj}]" }
    end
    obj
  end

  class << self
    alias_method(:apply_to, :fetch_keys)
  end

  def self.namespace(namespace)
    @namespace = namespace
    @keylist = nil
    @namespace
  end

  # Load the keyfile. By default, the keystore is loaded if necessary by
  # the using functions, so it is unnecessary to call this directly.
  def self.load_keyfile
    if File.file?(keyfile_location)
      @key_list = YAML.pre_keyth_load(File.open(keyfile_location))
    else
      @key_list = {}
    end
  end

  # Save the keyfile. By default, the keystore is saved when changes are
  # made to it, so it is unnecessary to call this directly.
  def self.save_keyfile
    load_keyfile unless @key_list
    File.open(keyfile_location, 'w') { |f| f.write @key_list.to_yaml }
  end

  private

  def self.keyfile_location
    @namespace = 'default' unless @namespace
    ENV['KEYTH_KEYFILE'] || File.join(Dir.home, '.keyth', @namespace + '.yml')
  end
end
