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
        while (arg = args.pop)
          if arg.kind_of? Array
            arg_required = arg[0] == :required 
          elsif arg.kind_of? Symbol
            short_option = arg.to_s
          elsif arg.kind_of? String
            usage = arg
          end
        end
        Storage << Yagl::Option.new(opt.to_s, short_option, arg_required, usage)
      end
    end
  end
end
