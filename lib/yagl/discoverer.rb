require "fileutils"
module Yagl
  include FileUtils
  
  class Discoverer
    def initialize
      @dir=Dir.pwd
    end
    def match_sizes(templates)
      templates.map {|m| m.length}
    end
    def min_element(arry, min)
      arry.select {|m| m.length == min}[0]
    end
    def templates
      matches = Dir['**/template*']
      if matches.empty?
        nil
      else
        min_element(matches, match_sizes(matches).min)
      end
    end
  end
end