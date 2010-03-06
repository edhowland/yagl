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
    def delete_method(name)
      self.class.send(:remove_method, name)
    end
    def set!(opt, truth=true)
      create_method(imperative(opt)) do
        delete_method(predicate(opt))
        create_method(predicate(opt)) {true}
        true
      end
      create_method(predicate(opt)) {truth}
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
  it "should define green? method" do
    set! "green"
    self.class.should be_method_defined(:green?)
  end
  it "should return true" do
    set! "green"
    green!.should be_true
  end
  it "should return true for green?" do
    set! "green"
    green?.should be_true
  end
  
  it "should return false for green?" do
    set! "green", false
    green?.should be_false
  end
  
  it "should redfine green? after green! called" do
    set! "green", false
    green?.should be_false
    green!
    green?.should be_true
    
  end
end

module Yagl
  module SetOption
    module Parser
      def parse(opt)
        (opt[1..-1].split(/-/))[1..-1].reverse.map {|o| o == 'no' ? true : o}
      end
    end
  end
end

describe "Yagl::SetOption::Parser" do
  include Yagl::SetOption::Parser
  it "should return opt, no_opt for --no-opt" do
    opt, no_opt = parse '--no-opt'
    opt.should == "opt"
    no_opt.should be_true
  end
  it "should return opt and nil for --opt" do
    opt, no_opt = parse '--opt'
    opt.should == 'opt'
    no_opt.should be_nil
  end
end

# integration test
module Yagl
  module SetOption
    module SetMethod
      include Yagl::SetOption::Parser
      include Yagl::SetOption
      def methods_from_option(opt)
        option, no_option = parse opt
        if no_option
          set! option, false
        else
          set! option
        end
      end
    end
  end
end

describe "MethodSetter" do
  include Yagl::SetOption::SetMethod
  it "should do set green! from --green" do
    methods_from_option '--green'
    green!.should be_true
  end
  it "should define green? which is true for --green" do
    methods_from_option '--green'
    green?.should be_true
  end
  it "should define green? and should be false with --no-green" do
    methods_from_option '--no-green'
    green?.should be_false
  end
  it "should be not be green, then after green! it should be green" do
    methods_from_option '--no-green'
    green?.should be_false
    green!
    green?.should be_true
  end
end
