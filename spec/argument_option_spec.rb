require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "getoptlong"

describe "options with arguments" do
  include Yagl::DSL::Commands
  
  it "should take an argument and have argument? true" do
    opt = Yagl::Option.new('url', nil, true)
    opt.should be_argument
  end
  it "should take no argument and have argument? false" do
    opt = Yagl::Option.new('url')
    opt.should_not be_argument
  end
  
  it "should have upper case argument name in usage" do
    opt = Yagl::Option.new('url', nil, true)
    opt.arg_usage.should == ' URL'
  end
  
  it "should not have upper case argument name" do
    opt = Yagl::Option.new('url')
    opt.arg_usage.should be_empty
  end
  
  it "should have usage message -u, --url URL      Show this url" do
    opt = Yagl::Option.new('url', nil, true)
    opt.usage.should == '-u, --url URL                  Show this url'
  end
  
  describe "DSL option command" do
    it "should take an argument via :required flag and have argument? true" do
      option :url, [:required]
      opt = Storage.last
      opt.should be_argument
    end
    
    it "should take an argument via :argument flag and have argument? true" do
      option :url, [:argument]
      opt = Storage.last
      opt.should be_argument
    end  
  end
end