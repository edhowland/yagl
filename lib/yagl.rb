require "fileutils"

module Yagl
  include FileUtils
  
  class Discoverer
    def initialize
      @dir=Dir.pwd
    end
    def templates
      matches = Dir['**/templates']
      if matches.empty?
        nil
      else
        matches[0]
      end
    end
  end
  
  class Copier
    attr_accessor :src, :dest
    def initialize(src, dest)
      @src = src
      @dest = File.expand_path dest
    end
    def copy!
      Dir.chdir(@src) do
        FileUtils::cp_r '.', @dest, :verbose => true
      end
    end
  end

  class Option
    attr_accessor :long, :short, :required_arg
    def initialize(long, short=nil, required_arg=false)
      @short = short
      @long = long
      @short = @long[0] if short.nil?
      @required_arg = required_arg
    end
    def long_option
      "--#{@long}"
    end
    def short_option
      "-#{@short}"
    end
    def to_a
      arry=[]
      arry << short_option if @short
      arry << long_option
      arry << (@required_arg ? GetoptLong::REQUIRED_ARGUMENT : GetoptLong::NO_ARGUMENT)
    end
    def arg_format
        @required_arg ? "GetoptLong::REQUIRED_ARGUMENT" : "GetoptLong::NO_ARGUMENT"
    end
    def to_s
      arry=to_a
      str="["
      arry[0..-2].each do |e|
        str << "\'#{e}\', "
      end
      str << "#{arg_format}]"
    end
  end
end



def die(msg, failed=false)
  puts msg; exit(failed ? -1 : 0)
end