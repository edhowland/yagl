$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'yagl'

require 'spec/expectations'
require 'fileutils'
include FileUtils

def path(*args)
  File.join(*args)
end

$dirs=[]
def pushd(dir)
  $dirs.push Dir.pwd
  Dir.chdir dir
end

def popd
  Dir.chdir $dirs.pop
end

def dirs
  $dirs
end

