require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "getoptlong"

describe Yagl::Option do
  describe "long_option" do
    it "should be --help" do
      option = Yagl::Option.new('help')
      option.long_option.should == '--help'
    end
    it "should be -h" do
      option = Yagl::Option.new('help')
      option.short_option.should == '-h'
    end
  end
  
  it "should interpret short option from long" do
    option = Yagl::Option.new('help')
    option.to_s.should == "['--help', '-h', GetoptLong::NO_ARGUMENT]"
  end
  it "should be explicit about short" do
    option = Yagl::Option.new('help', 'x')
    option.to_s.should == "['--help', '-x', GetoptLong::NO_ARGUMENT]"
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
      option.to_a.should == ['--help', '-h', GetoptLong::NO_ARGUMENT]
    end
    it "should have no short varient when false" do
      option = Yagl::Option.new('help', false)
      option.to_a.should == ['--help', GetoptLong::NO_ARGUMENT]
    end
    it "should have required argument" do
      option = Yagl::Option.new('url', nil, true)
      option.to_a.should == ['--url', '-u', GetoptLong::REQUIRED_ARGUMENT]
    end
  end
  describe "usage" do
    describe "inference" do
      it "should have an empty short option" do
        option = Yagl::Option.new('help', false)
        option.short_option.should be_empty
      end
      it "should infer a string from the option name" do
        option = Yagl::Option.new('help')
        option.infer.should == "Show this help"
      end
      it "should have a non-empty usage message" do
        option = Yagl::Option.new('verbose', nil, false, "Show lots of output")
        option.usage_msg.should_not be_empty
        option.usage_msg.should == "Show lots of output"
      end
      it "should use a supplied usage_msg" do
        option = Yagl::Option.new('verbose', nil, false, "Show lots of output")
        option.infer.should == "Show lots of output"
      end
    end
    it "should describe itself" do
      option = Yagl::Option.new('help')
      option.usage.should == "-h, --help                     Show this help"
    end

    it "should allow itself to be described" do
      option = Yagl::Option.new('verbose', 'V', false, "Show lots of output")
      option.usage.should == "-V, --verbose                  Show lots of output"
      
    end
  end
end