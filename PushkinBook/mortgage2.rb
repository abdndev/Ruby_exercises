sum = 500000             # Общая сумма ипотеки (стоимость дома)
total = 0                # переменная для подсчета общей суммы процентов по ипотеке

30.times do |n|
  sum = sum - 16666      # Отнимаем от остатка суммы ипотеки ежемесячный платеж
  perc = sum * 0.04      # Вычисляем проценты за кредит для остатка суммы
  perc = perc.to_i       # Приводим переменную к целому числу
  annual_perc = perc /(30 - n)
  total = total + annual_perc
  puts "Год #{n + 1}, проценты за кредит составляют: $#{annual_perc}"
end
puts
puts "Общая сумма процентов: $#{total}"
