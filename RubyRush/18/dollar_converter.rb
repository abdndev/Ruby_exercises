puts
puts 'Давай посчитаем сколько ты накопил на сегодняшний день деньжат (в долларах)...'
puts

print 'Сколько сейчас стоит 1 доллар в рублях?  '
ex_rate = gets.chomp.to_f

print 'Сколько у тебя рублей?  '
qty = gets.chomp.to_f

buck_value = (qty / ex_rate).round(2)
puts

puts 'Твои запасы в долларовом эквиваленте составляют на сегодня: ' +'$' + buck_value.to_s