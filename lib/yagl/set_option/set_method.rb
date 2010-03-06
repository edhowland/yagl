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
