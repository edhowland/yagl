require 'stringio'
str=StringIO.open do |s|
  s.puts 'hello'
  s.puts 'world'
  s.string
end
puts str


class StringIO
  def self.open_and_return(string='', *mode, &block)
    self.open do |s|
      yield s
      s.string
    end
  end
end

str=StringIO.open_and_return do |s|
  s.puts "hi"
  s.puts 'there'
end

puts str