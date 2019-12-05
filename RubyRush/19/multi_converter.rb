puts
puts 'Какая у вас на руках валюта?
1. Рубли
2. Доллары'
currency = gets.chomp
puts

puts 'Сколько сейчас стоит доллар?  '
usd_rate = gets.chomp.to_f
puts

if currency == '1'
  print 'Сколько у вас рублей?  '
    qty_rub = gets.chomp.to_f
    usd_value = (qty_rub / usd_rate).round(2)    # метод .round(2) позволяет отсечь лишние знаки после точки у вещественного числа
    puts
  puts 'Ваши запасы на сегодня равны: ' + '$' + usd_value.to_s
else
  print 'Сколько у вас долларов?  '
    qty_usd = gets.chomp.to_f
    rub_value = (qty_usd * usd_rate).round(2)
    puts
  puts 'Ваши запасы на сегодня равны: ' + rub_value.to_s + ' рублей'
end


