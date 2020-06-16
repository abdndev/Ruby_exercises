module MyNamespace
  class Array
    def to_s
      'my class'
    end
  end
end

p Array.new               # []
p MyNamespace::Array.new  #

puts Array.new            # nil
puts MyNamespace::Array.new  # my class
