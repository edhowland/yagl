require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "getoptlong"
require "stringio"

describe "Yagl::BinaryOption" do
  before(:each) do
    @option = Yagl::BinaryOption.new('ri')
  end
  it "should be an Option too" do
    @option.should be_kind_of Yagl::Option
  end
  
  it "should have the binary? true" do
    @option.should be_binary
  end
  
  it "should have -r for a short option" do
    @option.short_option.should == '-r'
  end
  
  it "should have --ri for a long option" do
    @option.long_option.should == '--ri'
  end
  
  it "should have --[no-]ri for a usage" do
    @option.usage.should match  %r{^\-r, \-\-\[no\-\]ri}
  end
  
  it "should have a parent_to_a" do
    @option.parent_to_a.length.should == 3
  end
  
  it "should create two arrays for to_a" do
    @option.to_a.length.should == 2
  end
  
  it "each item in to_a is an array for GetoptLong ctor" do
    @option.to_a.each do |opt| 
      opt.should be_kind_of Array
      opt.last.should == GetoptLong::NO_ARGUMENT
    end
  end
  
  it "should not raise error when used in splat for GoL ctor" do
    arry = [Yagl::Option.new('rdoc', 'R').to_a, 
            *@option.to_a,
            Yagl::Option.new('verbose').to_a
           ]
    lambda {GetoptLong.new(*arry)}.should_not raise_error
  end
  
  it "should execute splat conditionally if BinaryOption beacuse there are 2" do
    options = [Yagl::Option.new('quiet'), @option, Yagl::Option.new('verbose')]
    arry = []
    options.each do |opt|
      if opt.binary?
        arry.push(*opt.to_a)
      else
        arry << opt.to_a
      end
    end
    lambda {GetoptLong.new(*arry)}.should_not raise_error
  end
end