puts 'Игра "Битва Роботов"'
puts
puts 'В каждой команде по десять роботов'

# объявляем массивы для обеих команд
arr1 = Array.new(10, 100)
arr2 = Array.new(10, 100)

# выводим массивы на экран
puts "Команда 1: #{arr1}"
puts "Команда 2: #{arr2}"
puts

# основной цикл без использования методов
loop do
    puts 'Стреляет первая команда.'
    i = rand(0..9)
    d = rand(0..100)

    puts i 
    puts d 

    if arr1[i] == 0
        puts "Промазали по индексу #{i}"
    elsif (arr1[i] - d) < 0 || d == arr1[i] 
        arr1[i] = 0
        puts "Чужой робот по индексу #{i} уничтожен "
    elsif arr1[i] > 0
        arr1[i] = arr1[i] - d
        puts "Чужой робот по индексу #{i} получил ущерб #{d} единиц"
    end
    p arr1

    x = 0
    arr1.each do |element|
        if element > 0
            x += 1
        end
    end
    puts "Во второй команде осталось роботов: #{x}"

    if x == 0
        puts "Выиграла первая команда! Игра окончена!"
        exit
    end
    sleep 1
    puts

    puts 'Стреляет вторая команда.'
    i = rand(0..9)
    d = rand(0..100)
    
    puts i 
    puts d 

    if arr2[i] == 0
        puts "Промазали по индексу #{i}"
    elsif (arr2[i] - d) < 0 || d == arr2[i] 
        arr2[i] = 0
        puts "Чужой робот по индексу #{i} уничтожен "
    elsif arr2[i] > 0
        arr2[i] = arr2[i] - d
        puts "Чужой робот по индексу #{i} получил ущерб #{d} единиц"
    end
    p arr2

    x = 0
    arr2.each do |element|
        if element > 0
            x += 1
        end
    end
    puts "В первой команде осталось роботов: #{x}"

    if x == 0
        puts "Выиграла вторая команда! Игра окончена!"
        exit
    end
    sleep 1
    puts
end
