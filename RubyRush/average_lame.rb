puts 'Let\'s find the average of two numbers...'

print 'Enter first number: '
number1 = gets.to_f

print 'Enter second number: '
number2 = gets.to_f

puts 'First number is: ' + number1.to_s
puts 'Second number is: ' + number2.to_s

average = (number1 + number2) / 2

puts
puts 'The average of two numbers is: ' + average.to_s 