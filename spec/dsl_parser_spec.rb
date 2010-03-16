require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DSL Parser" do
  include Yagl::DSL::Autorun
  before(:each) do
    @src = %q{
    juggle :flip do
    end
    script :autorun do
      a = 1
      [1,2].each do |e|
      end
    end
    script :maker do
    end
    }
    @parser = Yagl::DSL::Parser.new(@src)
    @parser.parse
    create_methods!
  end
  it "should create an accessor method :autorun with string contents" do
    autorun.should be_instance_of String
  end
  it "should create an accessor method :builder" do
    maker.should_not be_nil
  end
  it "should not create one for :juggle" do
    -> {flip}.should raise_error
  end
  
  it "should push do block on stack" do
    @parser.block_stack.should_not be_empty
  end
  
  it "should be an s-exp" do
    @parser.block_stack.pop.should be_kind_of Array
  end
  
  it "should associate block with definitions" do
    Yagl::DSL::Parser.definitions[0].last.should be_kind_of Array
  end
  describe "pos?" do
    it "should detect a position" do
      @parser.pos?([1,0]).should be_true
    end
    it "should be false for larger sexps" do
      @parser.pos?([1,0, [:a]]).should be_false
    end
    it "should be false for non arrays" do
      @parser.pos?(1).should be_false
    end
    it "should be false if length != 2" do
      @parser.pos?([]).should be_false
      @parser.pos?([1]).should be_false
      @parser.pos?([1,2,3]).should be_false
    end
    it "should be false for first part being non Fixnum" do
      @parser.pos?([:a,1]).should be_false
    end
    it "should be false for last part not being Fixnum" do
      @parser.pos?([1,'x']).should be_false
    end
    
  end
end