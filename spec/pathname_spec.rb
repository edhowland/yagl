require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "splitting extension" do
  before(:each) do
    @fname = 'template/ruby/lib/yagl/yagl.rb.eruby'
    @p = Pathname.new @fname
  end
  it "should return final extension" do
    @p.final_ext.should == 'eruby'
  end
  it "should strip final extenstion" do
    @p.strip_final_ext.should == 'yagl.rb'
  end
  it "should return or regex clasue for array" do
    @p.or_clause_if_array(%w{eruby erb}).should == '(eruby|erb)'
  end
  it "should return a string for or caluse" do
    @p.or_clause_if_array('eruby').should == 'eruby'
  end
  it "should detect extension" do
    @p.match_final_ext('eruby').should be_true
  end
  it "should match multiple patterns" do
    @p.match_final_ext(%w{eruby erb}).should be_true
  end
  it "should match ,ultiple pattenrs with erb" do
    p = Pathname.new 'template/ruby/lib/yagl/yagl.rb.erb'
    p.match_final_ext(%w{eruby erb}).should be_true
  end
  it "should not match for no erb or eruby extension" do
    p = Pathname.new 'template/ruby/lib/yagl/yagl.rb'
    p.match_final_ext(%w{eruby erb}).should be_false
  end
  describe "parts" do
    it "must have parts" do
      @p.parts.should == %w{template ruby lib yagl yagl.rb.eruby}
    end
    it "should constuct it back" do
      q=Pathname.new('.')
      q.join(*@p.parts).to_s.should == @p.to_s
    end
  end
end