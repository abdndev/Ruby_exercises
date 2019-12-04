puts "Давайте вычислим среднее арифметическое трех чисел..."

a = gets.chomp.to_i
b = gets.chomp.to_i
c = gets.chomp.to_i

average = (a + b + c) / 3

puts 'Первое число: ' + a.to_s
puts 'Второе число: ' + b.to_s
puts 'Третье число: ' + c.to_s

puts 'Среднее арифметическое: ' + average.to_s