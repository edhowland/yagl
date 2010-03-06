module Yagl
  module SetOption
    module Parser
      def parse(opt)
        (opt[1..-1].split(/-/))[1..-1].reverse.map {|o| o == 'no' ? true : o}
      end
    end
  end
end
