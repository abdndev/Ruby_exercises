puts 'Игра "Битва Роботов"'
puts
puts 'В каждой команде по десять роботов'

arr1 = Array.new(10, 1)
arr2 = Array.new(10, 1)

puts "Команда 1: #{arr1}"
puts "Команда 2: #{arr2}"
puts

loop do
    puts 'Стреляет первая команда.'
    i = rand(0..9)
    if arr1[i] == 1
        arr1[i] = 0
        puts "Чужой робот по индексу #{i} убит"
    else
        puts 'Промазали!'
    end
    p arr1

    x = 0
    arr1.each do |element|
        if element == 1
            x += 1
        end
    end
    puts "Во второй команде осталось #{x} роботов"

    if x == 0
        puts "Выиграла первая команда! Игра окончена!"
        exit
    end
    sleep 1
    puts

    puts 'Стреляет вторая команда.'
    i = rand(0..9)
    if arr2[i] == 1
        arr2[i] = 0
        puts "Чужой робот по индексу #{i} убит"
    else
        puts 'Промазали!'
    end
    p arr2

    x = 0
    arr2.each do |element|
        if element == 1
            x += 1
        end
    end
    puts "В первой команде осталось #{x} роботов"

    if x == 0
        puts "Выиграла вторая команда! Игра окончена!"
        exit
    end
    sleep 1
    puts
end
