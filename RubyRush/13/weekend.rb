puts "Хочешь узнать выходной сегодня или нет. Нажми Enter:"
gets
puts
time = Time.now
week_day = time.wday

puts week_day
puts

if week_day == 0 || week_day == 6
  puts "Сегодня выходной!"
else
  puts "Сегодня будний день, за работу!"
end