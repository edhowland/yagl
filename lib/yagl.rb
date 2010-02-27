require "yagl/discoverer"
require "yagl/copier"
require "yagl/option"
require "yagl/option_group"

def die(msg, failed=false)
  puts msg; exit(failed ? -1 : 0)
end