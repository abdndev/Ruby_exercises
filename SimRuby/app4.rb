puts "Данная программа предназначена для подбора нужного числа, путем перебора чисел."

print "Введите (пятизначное) число, программа попытается подобрать его: "
number = gets.to_i
puts

(0..1000000000).each do |x|
  print "\r#{x} <--- Ищем число"
  if x == number
    puts
    puts
    print "Подбор завершен, загаданное число: #{x}"
    puts
    exit
  end
end

