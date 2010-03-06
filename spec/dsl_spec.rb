require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Yagl
  module DSL
    module Commands
      class Storage
        @@commands = []
        def self.clear
          @@commands.clear
        end
        def self.<<(command)
          @@commands << command
        end
        def self.length
          @@commands.length
        end
        def [](index)
          @@comands[index]
        end
        def self.first
          @@commands.first
        end
        def self.last
          @@commands.last
        end
      end
      
      def option(opt, *args)
        arg_required = false
        short_option = nil
        usage = ''
        if args[0].kind_of? Array
          arg_required = args[0][0] == :required 
        elsif args[0].kind_of? Symbol
          short_option = args[0].to_s
        elsif args[0].kind_of? String
          usage = args[0]
        end
        Storage << Yagl::Option.new(opt.to_s, short_option, arg_required, usage)
      end
    end
  end
end

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
end