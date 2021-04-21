Array.new(5) { Array.new(4) { rand(0..9) } } # Создать массив 5 на 4 и заполнить весь массив абсолютно случайными значениями от 0 до 9.
ary = Array.new(5) { Array.new(4) { rand(0..9) } }
puts ary
