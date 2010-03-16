require 'ripper'
require "pp"

module Yagl
  module DSL
    class Parser < Ripper::SexpBuilder
      @@definitions = []
      attr_accessor :block_stack
      def initialize(src)
        @@definitions.clear
        @block_stack = []
        super src
      end
      def on_program(*args)
        @@definitions.reject! {|e| e.first != :script}  
      end
      def on_command(*args)
        ident = args[0]
        script = ident[1].to_sym
        if script == :script
          @@definitions.last << script
          @@definitions.last.reverse!
          @@definitions.last << @block_stack.pop
        end
      end
      def on_symbol(*args)
        ident = args[0]
        @@definitions << [ident[1].to_sym]
      end
      def on_do_block(*args)
        pp args
        @block_stack << args
      end
      
      
      def self.definitions
        @@definitions
      end
    end
    module Autorun
    include Yagl::SetOption
    def create_methods!
      puts "Parser.defs"
      pp Parser.definitions
      puts "----"
      Parser.definitions.each do |definition|
        if definition.first == :script
          create_method(definition[1]) {''}
        end
      end
    end
    end 
  end
end