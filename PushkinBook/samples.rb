Array.new(5) { Array.new(4) { rand(0..9) } } # Создать массив 5 на 4 и заполнить весь массив абсолютно случайными значениями от 0 до 9.


[11, 22, 33, 44, 55].count(&:even?)   # С помощью указателя на функцию посчитать количество четных элементов в массиве
[0, 0, 1, 1, 0, 0, 1, 0].count { |x| x == 0} # использование метода .count для вычисления количества нулевых значений в массиве. Метод .count может принимать блок.

arr = [ [30, 1], [25, 0], [64, 1], [64, 0], [33, 1] ] # первый элемент каждого подмассиса - возраст, второй элемент - пол(муж - 1, жен - 0)
arr.select { |element| element[0] == 64 && element[1] == 1} # выбираем мужчин в возрасте 64 лет (выбран 1 элемент)
arr.select { |element| element[1] == 1} # выбираем всех мужчин (выбрано 3 элемента)
arr.reject { |element| element[0] >= 27 } # отсеять всех  мужчин старше двадцати семи лет (и выслать остальным повестку в военкомат)

[11, 22, 33, 44, 55].take(2) # метод .take принимает параметр (число) и берет определенное этим параметром количество элементов в начале массива
[20, 34, 65, 23, 18, 44, 32].all? { |element| element >= 18 } # метод .all? позволяет убедиться что все элементы удовлетворяют требованиям (true если все значения больше или равны 18(лет))

[false, false, false, true, false].any? { |element| element == true } # метод .any? позволяет узнать есть ли в массиве хоть одно совпадение (в данном случае: true), и выведет в случае успеха - true, если нет - false)
[false, false, false, true, false].find_index { |element| element == true } # метод .find_index показываете индекс искомого элемента в массиве - 3, в данном случае

-------------------------------------------------------------------------------------------------------------------------------------------------
# Передача опций в методы
# Conventional method (обычный метод)
def total_weight(soccer_ball_count, tennis_ball_count, golf_ball_count)
  #...
end

x = total_weight(3, 2, 1)

# Хеш с параметрами, вызов этого метода без параметров выдаст ошибку
def total_weight(options)
  a = options[:soccer_ball_count]
  b = options[:tennis_ball_count]
  c = options[:golf_ball_count]
  puts a 
  puts b 
  puts c  
  #...
end

params = { soccer_ball_count: 3, tennis_ball_count: 2, golf_ball_count: 1 }
x = total_weight(params)
--------------------------------------------------------------------------------

# Хеш с опциями по умолчанию
def total_weight(options={})
    a = options[:soccer_ball_count]
    b = options[:tennis_ball_count]
    c = options[:golf_ball_count]
    puts a 
    puts b 
    puts c  
    #...
  end

  x = total_weight(soccer_ball_count: 3, tennis_ball_count: 2, golf_ball_count: 1)
--------------------------------------------------------------------------------

# если в хеше options значение не указано (nil), то переменной будет присвоено значение "0", и ошибки не будет

def total_weight(options={})
    a = options[:soccer_ball_count] || 0
    b = options[:tennis_ball_count] || 0
    c = options[:golf_ball_count] || 0
    puts a 
    puts b 
    puts c  
    # (a * 410) + (b * 58) + (c * 45) + 29  # 29 - вес коробки
  end

  x = total_weight(soccer_ball_count: 3, tennis_ball_count: 2, golf_ball_count: 1)
  puts x
  