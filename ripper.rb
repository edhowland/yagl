require 'ripper'
require "pp"

class DemoBuilder < Ripper::SexpBuilder
  def pos?(sexp)
    if sexp.kind_of? Array
      if sexp.length == 2 and sexp[0].instance_of? Fixnum and sexp[1].instance_of? Fixnum
        true
      else
        false
      end
    end
  end

  def walk(sexp)
    @max_row ||= 0
    sexp.each do |exp|
      if pos? exp
        @max_row = exp[0] unless exp[0] <= @max_row
      else
        if exp.kind_of? Array
          walk exp
        end
      end
    end
  end

  def on_do_block(*args)
    walk args
    puts "max row in do block #{@max_row} "
  end
  def on_fcall(*args)
    ident = args[0]
    puts 'fcall ' + ident[2][0].to_s if ident[1] == 'script'
  end
end

src=File.read(ARGV[0])
DemoBuilder.new(src).parse

