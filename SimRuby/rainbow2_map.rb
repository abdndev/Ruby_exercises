require_relative 'rainbow2'

r = Rainbow.new
colors = r.map(&:upcase)
p colors
