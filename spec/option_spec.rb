require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "getoptlong"

describe Yagl::Option do
  it "should interpret short option from long" do
    option = Yagl::Option.new('help')
    option.to_s.should == "['-h', '--help', GetoptLong::NO_ARGUMENT]"
  end
  it "should be explicit about short" do
    option = Yagl::Option.new('help', 'x')
    option.to_s.should == "['-x', '--help', GetoptLong::NO_ARGUMENT]"
  end
  it "should have no short option" do
    option = Yagl::Option.new('help', false)
    option.to_s.should == "['--help', GetoptLong::NO_ARGUMENT]"
  end
  describe "arg_format" do
    it "should return 'GetoptLong::NO_ARGUMENT'" do
      option = Yagl::Option.new('help')
      option.arg_format.should == "GetoptLong::NO_ARGUMENT"
    end
    it "should return 'GetoptLong::REQUIRED_ARGUMENT'" do
      option = Yagl::Option.new('url', false, true)
      option.arg_format.should == "GetoptLong::REQUIRED_ARGUMENT"
    end
  end
  
  describe "to_a" do
    it "should have all option alternatives in array" do
      option = Yagl::Option.new('help')
      option.to_a.should == ['-h', '--help', GetoptLong::NO_ARGUMENT]
    end
    it "should have no short varient when false" do
      option = Yagl::Option.new('help', false)
      option.to_a.should == ['--help', GetoptLong::NO_ARGUMENT]
    end
    it "should have required argument" do
      option = Yagl::Option.new('url', nil, true)
      option.to_a.should == ['-u', '--url', GetoptLong::REQUIRED_ARGUMENT]
    end
  end
end