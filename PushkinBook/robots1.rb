puts 'Robot battle game'

arr1 = Array.new(10, 1)
arr2 = Array.new(10, 1)
p arr1
loop do
    puts 'Стреляет первая команда.'
    i = rand(0..9)
    if arr1[i] == 1
        arr1[i] = 0
        puts "Робот по индексу #{i} убит"
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
    sleep 1
    puts

    puts 'Стреляет вторая команда.'
    i = rand(0..9)
    if arr2[i] == 1
        arr2[i] = 0
        puts "Робот по индексу #{i} убит"
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
    sleep 1
    puts
end
