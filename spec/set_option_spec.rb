require File.expand_path(File.dirname(__FILE__)) +'/spec_helper'

module Yagl
  module SetOption
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
  include Yagl::SetOption
  it "should return imperative :xxy!" do
    imperative('xxy').should == :xxy!
  end
  it "should return predicate zzx?" do
    predicate('xxy').should == :xxy?
  end
  it "should define a opt! method" do
    set! "opt"
    self.class.should be_method_defined(:opt!)
  end
  it "should define a mod! method" do
    set! "mod"
    self.class.should be_method_defined(:mod!)
  end
  it "should return true" do
    set! "green"
    green!.should be_true
  end
  
end