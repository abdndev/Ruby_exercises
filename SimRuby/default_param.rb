def convert(value, factor = 1000)
  value * factor
end

puts convert(11)        # 11000
puts convvert(11, 1024) # 11264