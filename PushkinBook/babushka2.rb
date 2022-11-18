sum = 0                                                  # начальная сумма

24.times do |i|
  sum = sum + 500 + sum * 0.1
  puts "Месяц #{i + 1}, у бабушки в сундуке #{sum}"
end
