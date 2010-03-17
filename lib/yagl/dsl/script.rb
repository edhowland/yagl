require 'ripper2ruby'

module Yagl
  module DSL
    class Script
      class Element
        attr_accessor :block, :identifier, :symbol
        def initialize(block, identifier, symbol)
          @block = block
          @identifier = identifier
          @symbol = symbol.to_sym
        end
        def script?
          @identifier == 'script'
        end
      end
      def initialize(src)
        @elements = []
        @code = Ripper::RubyBuilder.build(src)
        @calls = @code.select(Ruby::Call)
        @calls.each do |c|
          # @elements << Element.new
          sym = :empty
          ids = c.select(Ruby::Identifier)
          unless ids.empty?
            id = ids.first.token
          end
          syms = c.select(Ruby::Symbol)
          unless syms.empty? 
            sym = syms.first.identifier.token
          end
          src=''
          c.block.elements.each do |e|
            src << e.to_ruby + "\n"
          end
          @elements << Element.new(src, id, sym)
        end
        @elements.reject! {|e| !e.script?}
      end
      def hash
        result = {}
        @elements.each do |element|
          result[element.symbol] = element.block
        end
        result
      end
    end

    module MethodBody
      include Yagl::SetOption
      def create_methods!(method_bodys)
        method_bodys.each do |name, body|
          create_method(name) {body}
        end
      end
    end 
    
  end
end
