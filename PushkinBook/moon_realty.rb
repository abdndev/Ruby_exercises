puts 'The Moon realty program'
puts
puts 'You can calculate the cost of the moon realty'
puts

print 'Enter the length: '
length = gets.to_i
print 'Enter the width: '
width = gets.to_i
puts

square = length * width
puts "The square of your moon real estate is: #{square}"

if square < 50
  puts "The cost of your real estate is: $1000"
end

if square >= 50 && square < 100
  puts "The cost of your real estate is: $1500"
end

if square >= 100
  puts "The cost of your real estate is: " + "$" + (square * 25).to_s
  #puts "The cost of your real estate is: $#{square * 25}"
end

