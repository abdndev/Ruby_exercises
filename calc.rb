puts "Введите первое число: "

num1 = gets.to_i

puts "Введите второе число: "

num2 = gets.to_i

ops = %w[ + - * / ]

until ops.empty? puts "Введите операцию (+, -, *, /): "

op = gets.strip
