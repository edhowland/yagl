module Yagl
  module SetOption
    module SetMethod
      include Yagl::SetOption::Parser
      include Yagl::SetOption

      def default_from_option(opt)
        option, dummy = parse opt
        set! option, false
      end
      
      def methods_from_option(opt)
        option, no_option = parse opt
        if no_option
          set! option, false
        else
          set! option
        end
      end

      def accessors_from_option(opt, arg)
        option, no_option = parse opt
        if no_option
          create_accessors! option, nil
        else
          create_accessors! option, arg
        end
      end
    end
  end
end
