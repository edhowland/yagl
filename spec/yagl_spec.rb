require 'fileutils'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include FileUtils

describe "Yagl" do
  describe "Discoverer" do
    before(:all) do
      @dir = File.expand_path(File.dirname(__FILE__) + '/templates')
      mkdir_p @dir
      Dir.chdir File.expand_path(File.dirname(__FILE__))
    end
    before(:each) do
      @discoverer = Yagl::Discoverer.new
    end
    it "should discover the templates folder" do
      @discoverer.templates.should == 'templates'
    end
    it "should discuver spec/templates" do
      Dir.chdir(File.expand_path(File.dirname(__FILE__)) + '/..')
      @discoverer.templates.should == 'spec/templates'
    end
    it "should discover no templates" do
      Dir.chdir(File.expand_path(File.dirname(__FILE__)) + '/../features')
      @discoverer.templates.should be_nil
    end
  end
  
  describe "copier" do
    before(:all) do
      @root = File.expand_path(File.dirname(__FILE__)) 
      @tmp =  @root + '/tmp/gem'
      Dir.chdir @root
      mkdir_p @tmp
      puts "@tmp #{@tmp}"
      rm_rf(Dir[@tmp+'/*'])
    end
    before(:each) do
      @discoverer = Yagl::Discoverer.new
      @copier = Yagl::Copier.new(@discoverer.templates, @tmp)
    end
    it "should have src be empty" do
      Dir[@tmp+'/**'].should be_empty
    end
    it "should copy nothing for empty templates" do
      rm_rf(Dir['templates/*'])
      
      @copier.copy!
      Dir[@tmp+'/**'].should be_empty
    end
    it "should copy 1 file" do
      puts Dir.pwd
      touch File.join(@discoverer.templates, 'file.rb'), :verbose => true
      @copier.copy!
      Dir[@tmp+'/**'].should_not be_empty
    end
  end
end
