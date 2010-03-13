require File.expand_path(File.dirname(__FILE__)) +'/spec_helper'


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

  describe "creating accessors" do
    it "should create get accessor with name of argument" do
      create_accessors! :color, 'green' 
      color.should == 'green'
    end
    def test
      
    end
    it "should create set accessor with name of argument" do
      create_accessors! :color, 'green'
      self.class.method_defined?(:test).should be_true
      self.class.method_defined?(:color=).should be_true
      color=('red')
      color.should == 'red'
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
