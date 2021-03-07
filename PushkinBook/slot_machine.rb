print 'Ваш возраст: '
age = gets.to_i
if age < 18
  puts 'Сожалеем, но вам нет 18'
  exit
end

balance = 20

loop do
puts 'Нажмите Enter, чтобы дернуть ручку...'
x = rand(0..5)
y = rand(0..5)
z = rand(0..5)

puts "Результат: #{x} #{y} #{z}"

if x == 0 && y == 0 && z == 0
  balance = 0
  puts 'Ваш баланс обнулен'
end


end
