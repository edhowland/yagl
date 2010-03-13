$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
require "set_option/parser"
require "set_option/set_method"

module Yagl
  module SetOption
    def symbolize(arg, append); (arg+append).to_sym; end
    def imperative(arg); symbolize(arg, '!'); end
    def predicate(arg); symbolize(arg, '?'); end
    
    def create_method(name, &block)
      self.class.send(:define_method, name, &block)
    end
    def delete_method(name)
      self.class.send(:remove_method, name)
    end
    def set!(opt, truth=true)
      create_method(imperative(opt)) do
        delete_method(predicate(opt))
        create_method(predicate(opt)) {true}
        true
      end
      create_method(predicate(opt)) {truth}
    end
    def create_accessors!(opt, value)
      create_method(opt) {value}
      create_method(symbolize(opt.to_s, '=')) do |value|
        delete_method(opt)
        create_method(opt) {value}
      end
    end
  end
end
