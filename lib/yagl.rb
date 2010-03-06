require "yagl/discoverer"
require "yagl/copier"
require "yagl/option"
require "yagl/option_group"

def die(msg=nil, failed=false)
  puts msg unless msg.nil?
  exit(failed ? -1 : 0)
end