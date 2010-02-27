module Yagl
  require "fileutils"
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