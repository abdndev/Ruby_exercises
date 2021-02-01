sum = 500000

30.times do |n|
  sum = sum - 16666 
  perc = sum * 0.04
  perc = perc.to_i
  annual_perc = perc /(30 - n)
  puts "Год #{n + 1}, проценты за кредит составляют: $#{annual_perc}"
end