# Моя переделанная версия программы по заданию книги

#############################################
# ОБЪЯВЛЯЕМ МАССИВЫ
#############################################

# массив для первой команды
@arr1 = Array.new(10, 100)
# массив для второй команды
@arr2 = Array.new(10, 100)

#############################################
# АТАКА
#############################################

# Метод принимает массив для атаки
def attack(arr)
  sleep 1 # добавим sleep для красоты
  @i = rand(0..9)
  if arr[@i] > 0
    puts "Попадание в робота по индексу: #{@i}"
  else
    puts "Промазали по индексу #{@i}"
  end
  sleep 1 # еще один sleep для красоты вывода
end

#############################################
# УЩЕРБ
#############################################

def damage(arr)                                  # метод для определения ущерба при попадании в робота
  d = rand(1..100)                               # переменная получающая случайное значение ущерба
  if arr[@i] > 0 && (arr[@i] - d) > 0            # условие при котором будет начисляться число ущерба
    arr[@i] = arr[@i] - d                        # число ущерба отнимаем от текущего значения "здоровья" робота
    puts "Робот по индексу #{@i} получил ущерб #{d} единиц"
  elsif (arr[@i] - d) < 0 || d == arr[@i]        # условие для случая когда выпавший ущерб превышает или равен остатку "здоровья" робота
    arr[@i] = 0                                  # таким образом исключаются отрицательные значения "здоровья" робота
    puts "Робот по индексу #{@i} уничтожен!"
  end
  
end

#############################################
# ПРОВЕРКА ПОБЕДЫ
#############################################

def victory?
  robots_left1 = @arr1.count { |x| x > 0}
  robots_left2 = @arr2.count { |x| x > 0}

  if robots_left1 == 0
    puts "Команда 2 победила, в команде осталось роботов: #{robots_left2}"
    return true
  end

  if robots_left2 == 0
    puts "Команда 1 победила, в команде осталось роботов: #{robots_left1}"
    return true 
  end
end

#############################################
# СТАТИСТИКА
#############################################

def stats
  # количество живых роботов для первой и второй команды
  cnt1 = @arr1.count { |x| x > 0 }
  cnt2 = @arr2.count { |x| x > 0 }
  puts "1-ая команда: роботов в строю: #{cnt1}"
  p @arr1
  puts "2-ая команда: роботов в строю: #{cnt2}"
  p @arr2
end

#############################################
# ГЛАВНЫЙ ЦИКЛ
#############################################

loop do
  puts 'Первая команда наносит удар...'
  attack(@arr2)
  damage(@arr2)
  exit if victory?
  stats
  sleep 2
  puts # пустая строка

  puts 'Вторая команда наносит удар...'
  attack(@arr1)
  damage(@arr1)
  exit if victory?
  stats
  sleep 2
  puts # пустая строка
end

