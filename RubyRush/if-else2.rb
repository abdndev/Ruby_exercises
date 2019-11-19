
puts 'Поздоровайтесь (Салют! или Привет!)...'

hello = gets.strip

puts "Я сказал #{hello}"

if hello != 'Салют!'&& hello != 'Привет!'

    puts 'Хам!'

else

    puts 'Привет!'

end