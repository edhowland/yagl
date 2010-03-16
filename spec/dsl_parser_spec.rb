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
end