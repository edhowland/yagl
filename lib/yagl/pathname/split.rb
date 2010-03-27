require "pathname"

class Pathname
  def ext_parts
    basename.to_s.split(/\./)
  end
  def final_ext
    ext_parts.pop
  end
  def or_clause_if_array(arg)
    if arg.kind_of? Array
      '(' + arg.join('|') + ')'
    else
      arg
    end
  end
  def match_final_ext(pattern)
    if final_ext =~ %r{#{or_clause_if_array(pattern)}}; true; else; false; end
  end
  def strip_final_ext
    arry = ext_parts
    arry.pop
    arry.join('.')
  end
  def parts
    self.to_s.split %r{/}
  end
end
