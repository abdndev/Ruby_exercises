require_relative 'rainbow2'

r = Rainbow.new
puts r.find { |c| c.start_with? 'ж' }  # желтый
