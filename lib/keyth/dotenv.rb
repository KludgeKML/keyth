# encoding: utf-8
# Monkey-patch DotEnv if in use to substitute keys when applying
module Dotenv
  # The two apply functions are all that need to be overwritten
  class Environment
    def apply
      each do |k, v|
        if v =~ /^keyth\:(.*)/
          ENV[k] = Keyth.get_key_safe(Regexp.last_match[1]) || ''
        else
          ENV[k] ||= v
        end
      end
    end

    def apply
      each do |k, v|
        if v =~ /^keyth\:(.*)/
          ENV[k] = Keyth.get_key_safe(Regexp.last_match[1]) || ''
        else
          ENV[k] = v
        end
      end
    end
  end
end