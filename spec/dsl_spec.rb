require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "DSL" do
  include Yagl::DSL::Commands
  before(:each) do
    Storage.clear
  end
  it "should create Yagl::Option from option" do
    option :help
    Storage.length.should > 0
  end
  it "should store Yagl::Option" do
    option :help
    Storage.last.should be_kind_of Yagl::Option
  end
  it "should store Yagl::Option with long_otion of --help" do
    option :help
    Storage.last.long_option.should == '--help'
  end
  it "should allow a different short option" do
    option :verbose, :V
    Storage.last.short_option.should == '-V'
  end
  it "should store required argument option" do
    option :url, [:required]
    Storage.last.required_arg.should be_true
  end
  it "should not have a required argument" do
    option :url
    Storage.last.required_arg.should be_false
  end
  it "should take a description" do
    option :help, "Show this help"
    Storage.last.usage_msg.should == 'Show this help'
  end
  it "should take short, required" do
    option :url, :U, [:required]
    opt = Storage.last
    opt.short_option.should == '-U'
    opt.required_arg.should be_true
  end
  it "should take required and usage" do
    option :url, [:required], "The site to search"
    opt = Storage.last
    opt.short_option.should == '-u'
    opt.required_arg.should be_true
    opt.usage_msg.should == 'The site to search'
  end
  it "should take all three" do
    option :url, :U, [:required], "The site to search"
    opt = Storage.last
    opt.short_option.should == '-U'
    opt.required_arg.should be_true
    opt.usage_msg.should == 'The site to search'
  end
end