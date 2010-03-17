require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "fileutils"

include FileUtils

describe "DSL::Script" do
  before(:each) do
    @src = %q{
a=4
def method(arg1, arg2)
  b=0
end

juggle :flip do
end
script :autorun do
  a = 1
  [1,2].each do |e|
end
  something = true
  nothing = false
end
script :maker do
  inf = -1
end
    }
    @script = Yagl::DSL::Script.new(@src)
  end
  
  # DEBUG
  def script(sym, &block);  end
  def juggle(sym, &block);  end
  
  it "should DEBUG script evals ok" do
    eval @src
  end
  it "should return hash of 2 elements" do
    @script.hash.length.should == 2
  end
  it "should have a :autorun key" do
    @script.hash[:autorun].should_not be_nil
  end
  it "should have a :maker key" do
    @script.hash[:maker].should_not be_nil
    
  end  
  
  it "should have a to_ruby for :autorun" do
    @script.hash[:autorun].should == %q{a = 1
[1,2].each do |e|
end
something = true
nothing = false
}
  end
  it "should have a to_ruvy for :maker" do
    @script.hash[:maker].should == "inf = -1\n"
  end
  describe "method bodys" do
    include Yagl::DSL::MethodBody
    before(:each) do
      create_methods!(@script.hash)
    end
    it "should bave a method autorun()" do
      autorun.should == %q{a = 1
[1,2].each do |e|
end
something = true
nothing = false
}
    end
    it "should have a maker method" do
      maker.should == "inf = -1\n"
    end
  end
end

describe "Yaglfile parsing" do
  before(:all) do
    q=%q{
script :autorun do
  v = 1
  q = 2
  puts v + q * 4
  puts "done"
end
    }
    @dir = File.expand_path(File.dirname(__FILE__) + '/tmp/spec_scratch')
    mkdir_p(@dir)
    
    @fname=@dir + '/Yaglfile'
    File.open(@fname, "w+") do |f|
      f.write(q)
    end
  end
  before(:each) do
    @script = Yagl::DSL::Script.new(File.read(@fname))
  end
  it "should read the file and parse it" do
    @script.hash.length.should == 1
    @script.hash[:autorun].should_not be_nil
  end
end

