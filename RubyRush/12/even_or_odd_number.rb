puts "Let's know even or odd number(Давайте узнаем четное или нечетное число)..."

print "Enter any number(Введите любое число): "
num = gets.to_i
puts
puts num
puts
if (num % 2) == 0
  puts "The number is even(Число является четным.)."
else
  puts "The number is odd(Число является нечетным)."
end