# encoding: utf-8
# Monkey-patch YAML to support auto-loading keyth keys
module YAML
  class << self
    alias_method(:pre_keyth_load, :load)
  end

  def self.load(file)
    Keyth.fetch_keys(pre_keyth_load(file))
  end
end