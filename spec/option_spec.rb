require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "getoptlong"
require "stringio"

describe Yagl::Option do
  describe "long_option" do
    it "should be --help" do
      option = Yagl::Option.new('help')
      option.long_option.should == '--help'
    end
    it "should be -h" do
      option = Yagl::Option.new('help')
      option.short_option.should == '-h'
    end
  end
  
  it "should interpret short option from long" do
    option = Yagl::Option.new('help')
    option.to_s.should == "['--help', '-h', GetoptLong::NO_ARGUMENT]"
  end
  it "should be explicit about short" do
    option = Yagl::Option.new('help', 'x')
    option.to_s.should == "['--help', '-x', GetoptLong::NO_ARGUMENT]"
  end
  it "should have no short option" do
    option = Yagl::Option.new('help', false)
    option.to_s.should == "['--help', GetoptLong::NO_ARGUMENT]"
  end
  describe "arg_format" do
    it "should return 'GetoptLong::NO_ARGUMENT'" do
      option = Yagl::Option.new('help')
      option.arg_format.should == "GetoptLong::NO_ARGUMENT"
    end
    it "should return 'GetoptLong::REQUIRED_ARGUMENT'" do
      option = Yagl::Option.new('url', false, true)
      option.arg_format.should == "GetoptLong::REQUIRED_ARGUMENT"
    end
  end
  
  describe "to_a" do
    it "should have all option alternatives in array" do
      option = Yagl::Option.new('help')
      option.to_a.should == ['--help', '-h', GetoptLong::NO_ARGUMENT]
    end
    it "should have no short varient when false" do
      option = Yagl::Option.new('help', false)
      option.to_a.should == ['--help', GetoptLong::NO_ARGUMENT]
    end
    it "should have required argument" do
      option = Yagl::Option.new('url', nil, true)
      option.to_a.should == ['--url', '-u', GetoptLong::REQUIRED_ARGUMENT]
    end
  end
  describe "usage" do
    describe "inference" do
      it "should have an empty short option" do
        option = Yagl::Option.new('help', false)
        option.short_option.should be_empty
      end
      it "should infer a string from the option name" do
        option = Yagl::Option.new('help')
        option.infer.should == "Show this help"
      end
      it "should have a non-empty usage message" do
        option = Yagl::Option.new('verbose', nil, false, "Show lots of output")
        option.usage_msg.should_not be_empty
        option.usage_msg.should == "Show lots of output"
      end
      it "should use a supplied usage_msg" do
        option = Yagl::Option.new('verbose', nil, false, "Show lots of output")
        option.infer.should == "Show lots of output"
      end
    end
    it "should describe itself" do
      option = Yagl::Option.new('help')
      option.usage.should == "-h, --help                     Show this help"
    end

    it "should allow itself to be described" do
      option = Yagl::Option.new('verbose', 'V', false, "Show lots of output")
      option.usage.should == "-V, --verbose                  Show lots of output"
    end
    
    it "should show usage w/o short option" do
      option = Yagl::Option.new('debug', false, false)
      option.usage.should == '--debug                        Show this debug'
    end
    
    it "should have usage_options == -r, --ri" do
      option = Yagl::Option.new('ri')
      option.usage_options.should == '-r, --ri'
    end
  end
  
  describe Yagl::OptionGroup do
    it "should have a name" do
      og = Yagl::OptionGroup.new 'Template'
      og.group_name.should == "Template options:"
    end
    
    it "should be a General options group by default" do
      og = Yagl::OptionGroup.new
      og.group_name.should == "General options:"
      
    end
    describe "holding options" do
      before(:each) do
        @og = Yagl::OptionGroup.new
        @og << Yagl::Option.new('help')
        @og << Yagl::Option.new('version')
        @og << Yagl::Option.new('debug', 'x', false, 'Show debug output')
      end
      it "should hold some options" do
        @og.to_s.should == <<-EOD
  General options:
     -h, --help                     Show this help
     -v, --version                  Show this version
     -x, --debug                    Show debug output
        EOD
      end
      it "should generate GetOptLong arrays of options" do
        str = StringIO.open do |s|
          comma = ''
          @og.each do |opt|
            s.print comma + opt.to_s
            comma = ",\n"
          end
          s.string + "\n"
        end
        str.should ==<<-EOD
['--help', '-h', GetoptLong::NO_ARGUMENT],
['--version', '-v', GetoptLong::NO_ARGUMENT],
['--debug', '-x', GetoptLong::NO_ARGUMENT]
            EOD
      end
      it "should format as GetOptLong array" do
        @og.format.should == %Q{['--help', '-h', GetoptLong::NO_ARGUMENT],
['--version', '-v', GetoptLong::NO_ARGUMENT],
['--debug', '-x', GetoptLong::NO_ARGUMENT]}

        
      end
    end
  end
  describe Yagl::MetaOptionGroup do
    before(:each) do
      @mog=Yagl::MetaOptionGroup.new
    end
    it "should hold some OptionGroups" do
      @mog << Yagl::OptionGroup.new('Template')
      @mog << Yagl::OptionGroup.new
      @mog.to_s.should == <<-EOD
  Template options:
  General options:
      EOD
    end
    describe "with complete OptionGroups" do
      before(:each) do
        templates = Yagl::OptionGroup.new('Template')
        templates << Yagl::Option.new('ruby', nil, false, 'install the ruby template')
        templates << Yagl::Option.new('ruby-19', false, false, 'install the ruby-19 template')

        generals = Yagl::OptionGroup.new
        generals << Yagl::Option.new('force', nil, false, "force overwriting files, don't ask")
        generals << Yagl::Option.new('skip', nil, false, 'skip file if it exists')
        generals << Yagl::Option.new('quiet', nil, false, 'runs quietly, no output')
        generals << Yagl::Option.new('verbose', 'V', false, 'Show lots of output')
        generals << Yagl::Option.new('version')
        generals << Yagl::Option.new('pretend', nil, false, 'dry run, show what would have happened')
        generals << Yagl::Option.new('debug', 'x', false, 'Show debugging output')
        generals << Yagl::Option.new('help')

        @mog << templates
        @mog << generals
        
      end
      it "should output a complete set of option groups with options" do
        @mog.to_s.should == <<-EOD
  Template options:
     -r, --ruby                     install the ruby template
     --ruby-19                      install the ruby-19 template
  General options:
     -f, --force                    force overwriting files, don't ask
     -s, --skip                     skip file if it exists
     -q, --quiet                    runs quietly, no output
     -V, --verbose                  Show lots of output
     -v, --version                  Show this version
     -p, --pretend                  dry run, show what would have happened
     -x, --debug                    Show debugging output
     -h, --help                     Show this help
            EOD
      end
      it "should format as all option groups to GetOptLong arrays" do
        @mog.format.should ==%Q{['--ruby', '-r', GetoptLong::NO_ARGUMENT],
['--ruby-19', GetoptLong::NO_ARGUMENT],
['--force', '-f', GetoptLong::NO_ARGUMENT],
['--skip', '-s', GetoptLong::NO_ARGUMENT],
['--quiet', '-q', GetoptLong::NO_ARGUMENT],
['--verbose', '-V', GetoptLong::NO_ARGUMENT],
['--version', '-v', GetoptLong::NO_ARGUMENT],
['--pretend', '-p', GetoptLong::NO_ARGUMENT],
['--debug', '-x', GetoptLong::NO_ARGUMENT],
['--help', '-h', GetoptLong::NO_ARGUMENT]}
      end
      it "should iterate over every option" do
        iter=0
        @mog.each do |opt|
          iter += 1
          opt.should be_kind_of Yagl::Option
        end
        iter.should_not be_zero
      end
    end
  end
end