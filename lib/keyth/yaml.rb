# encoding: utf-8
# Monkey-patch YAML to support auto-loading keyth keys
module YAML
  class << self
    alias_method(:pre_keyth_load, :load)
  end

  # loads the yaml file, then replaces all keyth: links with the
  # appropriate values.
  # Params:
  # +file+:: file object containing YAML to read
  def self.load(file)
    Keyth.fetch_keys(pre_keyth_load(file))
  end
end
