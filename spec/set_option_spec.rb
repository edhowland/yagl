require File.expand_path(File.dirname(__FILE__)) +'/spec_helper'

module Yagl
  class SetOption
    def imperative(arg)
      (arg+'!').to_sym
    end
    def predicate(arg)
      (arg+'?').to_sym
    end
    def create_method(name, &block)
      self.class.send(:define_method, name, &block)
    end
    def set!(opt)
      create_method(imperative(opt)) {true}
    end
  end
end

describe "set_option" do
  before(:each) do
    @option_setter = Yagl::SetOption.new
  end
  it "should return imperative :xxy!" do
    @option_setter.imperative('xxy').should == :xxy!
  end
  it "should return predicate zzx?" do
    @option_setter.predicate('xxy').should == :xxy?
  end
  it "should define a opt! method" do
    @option_setter.set! "opt"
    Yagl::SetOption.should be_method_defined(:opt!)
  end
  it "should define a mod! method" do
    @option_setter.set! "mod"
    Yagl::SetOption.should be_method_defined(:mod!)
  end
  it "should return true" do
    @option_setter.set! "green"
    @option_setter.green!.should be_true
  end
  
end