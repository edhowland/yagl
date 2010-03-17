require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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

