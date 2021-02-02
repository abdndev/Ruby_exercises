sum = 500000
total = 0

30.times do |n|
  sum = sum - 16666 
  perc = sum * 0.04
  perc = perc.to_i
  annual_perc = perc /(30 - n)
  total = total + annual_perc
  puts "Год #{n + 1}, проценты за кредит составляют: $#{annual_perc}"
end
puts
puts "Общая сумма процентов: $#{total}"
