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
end

def die(msg, failed=false)
  puts msg; exit(failed ? -1 : 0)
end