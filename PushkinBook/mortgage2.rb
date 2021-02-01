sum = 500000

30.times do |n|
  sum = sum - 16666
  perc = sum * 0.04
  perc = perc.to_i
  sum2 = sum + perc
  puts "Год #{n + 1}, осталоось выплатить $#{sum2}, из них проценты: $#{perc}"
end