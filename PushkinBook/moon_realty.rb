puts 'The Moon realty program'
puts
puts 'You can calculate the cost of the moon realty'
puts

print 'Enter the length: '
length = gets.to_i
print 'Enter the width: '
width = gets.to_i

square = length * width

if square < 50
  puts "The cost of your real estate is: $1000"
end

#if 50 <= square < 100
if square >= 50 && square < 100
  puts "The cost of your real estate is: $1500"
end

if square >= 100
  puts "The cost of your real estate is: $#{square * 25}"
end

