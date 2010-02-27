module Yagl
  class Option
    attr_accessor :long, :short, :required_arg, :usage_msg
    def initialize(long, short=nil, required_arg=false, usage='')
      @short = short
      @long = long
      @short = @long[0] if short.nil?
      @required_arg = required_arg
      @usage_msg = usage
    end
    def long_option
      "--#{@long}"
    end
    def short_option
      if @short
        "-#{@short}"
      else
        ''
      end
    end
    def to_a
      arry=[]
      arry << long_option
      arry << short_option if @short
      arry << (@required_arg ? GetoptLong::REQUIRED_ARGUMENT : GetoptLong::NO_ARGUMENT)
    end
    def arg_format
        @required_arg ? "GetoptLong::REQUIRED_ARGUMENT" : "GetoptLong::NO_ARGUMENT"
    end
    def to_s
      str="["
      to_a[0..-2].each do |e|
        str << "\'#{e}\', "
      end
      str << "#{arg_format}]"
    end
    
    def infer
      if usage_msg.empty?
        'Show this ' + long
      else
        @usage_msg
      end
    end
    
    def format_ws
      ' ' * (31 - (long_option.length+short_option.length + (@short ? 2 : 0)))
    end
    
    def usage
      to_a[0..-2].reverse.join(', ') + format_ws + infer
    end
  end
end
