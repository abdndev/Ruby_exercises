print 'Ваш возраст: '
age = gets.to_i
if age < 18
  puts 'Сожалеем, но вам нет 18'
  exit
end

balance = 20

loop do
puts 'Нажмите Enter, чтобы дернуть ручку...'
gets
x = rand(0..5)
y = rand(0..5)
z = rand(0..5)

puts "Результат: #{x} #{y} #{z}"

if x == 0 && y == 0 && z == 0
  balance = 0
  puts 'Вам не повезло! Ваш баланс обнулен! Игра закончена!'
  exit
elsif x == 1 && y == 1 && z == 1
  balance += 10
  puts 'Баланс увеличился на 10 долларов'
elsif x == 2 && y == 2 && z == 2
  balance += 20
  puts 'Баланс увеличился на 20 долларов'
elsif x == 3 && y == 3 && z == 3
  puts 'Баланс увеличился на 30 долларов'
  balance += 30
elsif x == 4 && y == 4 && z == 4
  puts 'Баланс увеличился на 40 долларов'
  balance += 40
elsif x == 5 && y == 5 && z == 5
  puts 'Баланс увеличился на 50 долларов'
  balance += 50
elsif x == 7 && y == 7 && z == 7
  puts 'Поздравляем, выпало счастливое число!'
  puts 'Баланс увеличился в десять раз!'
  balance = balance * 10
else
  balance -= 0.5
  puts 'Баланс уменьшился на 50 центов'
end

puts "Ваш баланс: #{balance} долларов"

end
