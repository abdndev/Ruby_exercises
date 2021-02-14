puts 'Сколько вам лет?'
age = gets.to_i
puts 'Являетесь ли вы членом партии Единая Россия? (y/n)'
answer = gets.chomp.downcase

if age >= 18 && answer == 'y'
  puts 'Вход на сайт разрешен'
end

