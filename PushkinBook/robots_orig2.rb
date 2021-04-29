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
  sleep 0.1 # добавим sleep для красоты
  @i = rand(0..9)
  if arr[@i] > 0
    #arr[@i] = 0
    puts "Попадание в робота по индексу: #{@i}"
  else
    puts "Промазали по индексу #{@i}"
  end
  sleep 0.1 # еще один sleep для красоты вывода
end

#############################################
# УЩЕРБ
#############################################

def damage(arr)
  d = rand(1..100)
  #if arr[@i] == 0
    #d == 0
    #arr[@i] = arr[@i] - d
  if arr[@i] > 0 && (arr[@i] - d) > 0
    arr[@i] = arr[@i] - d 
    puts "Робот по индексу #{@i} получил ущерб #{d} единиц"
  elsif (arr[@i] - d) < 0 || d == arr[@i]
    arr[@i] = 0
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
    puts "Команда 2 победила, в команде осталось #{robots_left2} роботов"
    return true
  end

  if robots_left2 == 0
    puts "Команда 1 победила, в команде осталось #{robots_left1} роботов"
    return false
  end

  false
end

#############################################
# СТАТИСТИКА
#############################################

def stats
  # количество живых роботов для первой и второй команды
  cnt1 = @arr1.count { |x| x > 0 }
  cnt2 = @arr2.count { |x| x > 0 }
  puts "1-ая команда: #{cnt1} роботов в строю"
  p @arr1
  puts "2-ая команда: #{cnt2} роботов в строю"
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
  sleep 1
  puts # пустая строка

  puts 'Вторая команда наносит удар...'
  attack(@arr1)
  damage(@arr1)
  exit if victory?
  stats
  sleep 1
  puts # пустая строка
end

