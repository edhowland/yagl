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
end