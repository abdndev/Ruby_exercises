sum = 500000

30.times do |n|
  sum = sum - 16666
  puts "Год #{n + 1}, осталось выплатить: $#{sum}"
end
