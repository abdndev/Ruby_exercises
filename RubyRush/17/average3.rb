puts 'Let\'s find the average of three numbers...'
puts

print 'Enter first number: '
num1 = gets.to_i

print 'Enter second number: '
num2 = gets.to_i

print 'Enter third number: '
num3 = gets.to_i
puts

puts "First number is: #{num1}"; puts "Second number is: #{num2}"; puts "Third number is: #{num3}"

average = (num1 + num2 + num3) / 3
puts
puts "The average of three numbers is: #{average}"