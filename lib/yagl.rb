require "yagl/discoverer"
require "yagl/copier"
require "yagl/option"
require "yagl/binary_option"
require "yagl/option_group"
require "yagl/set_option"
require "yagl/dsl"
require "yagl/pathname/split"

def die(msg=nil, failed=false)
  puts msg unless msg.nil?
  exit(failed ? -1 : 0)
end

class String; def blank?; empty?; end; end
class NilClass; def blank?; true; end; end