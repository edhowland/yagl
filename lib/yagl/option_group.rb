require "stringio"

module Yagl
  class MetaOptionGroup
    attr_accessor :option_groups
    def initialize
      @option_groups = []
    end
    
    def <<(option_group)
      @option_groups << option_group
    end
    
    def each(&block)
      @option_groups.each do |og|
        og.each(&block)
      end
    end
    
    def format
      StringIO.open do |s|
        comma = ''
        @option_groups.each do |og|
          s << comma + og.format
          comma = ",\n"
        end
        s.string
      end
    end
    
    def to_s
      StringIO.open do |s|
        @option_groups.each do |option_group|
          s << option_group.to_s
        end
        s.string
      end
    end
  end
  
  class OptionGroup
    attr_accessor :name, :options
    def initialize(name='General')
      @name=name
      @options = []
    end
    
    def group_name
      @name + ' options:'
    end
    
    def <<(option)
      options << option
    end
    
    def each(&block)
      options.each(&block)
    end
    
    def format
      str = StringIO.open do |s|
        comma = ''
        each do |opt|
          s.print comma + opt.to_s
          comma = ",\n"
        end
        s.string
      end
      str
    end
    
    def to_s
      StringIO.open do |s|
        s.puts '  ' + group_name
        options.each do |option|
          s.puts '     ' + option.usage
        end
        s.string
      end
    end
  end
end