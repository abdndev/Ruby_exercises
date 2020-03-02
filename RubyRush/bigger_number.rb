puts 'Давайте сравним два числа...'

print 'Введите первое число: '
number1 = gets.to_f

print 'Введите второе число: '
number2 = gets.to_f

puts "Первое число: #{number1}"
puts "Второе число: #{number2}"

if number1 > number2
    puts "Наибольшее число: #{number1}"
else
    puts "Наибольшее число: #{number2}"
end

if number1 == number2
    puts "Оба числа равны"
end