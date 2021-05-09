# Класс робота
class Robot 
  # Акцессоры - чтобы можно было узнать координаты снаружи
  attr_accessor :x, :y

  # Конструктор, принимает хеш. Если не задан - будет пустой хеш.
  # В хеше мы ожидаем два параметра - начальные координаты робота,
  # если не заданы, будут по-умолчанию равны нулю.
  def initialize(options={})
    @x = options[:x] || 0
    @y = options[:y] || 0
  end

  def right
    self.x += 1
  end

  def left 
    self.x -= 1
  end

  def up
    self.y += 1
  end

  def down
    self.y -= 1
  end

  # Новый метод - как отображать робота на экране
  def label
    '*'
  end
end

# Класс собаки, тот же самый интерфейс, но некоторые методы пустые.
class Dog
  # Акцессоры - чтобы можно было узнать координаты снаружи
  attr_accessor :x, :y

  # Конструктор, принимает хеш. Если не задан - будет пустой хеш.
  # В хеше мы ожидаем два параметра - начальные координаты собаки,
  # если не заданы, будут по-умолчанию равны нулю.
  def initialize(options={})
    @x = options[:x] || 0
    @y = options[:y] || 0
  end

  def right
    self.x += 1
  end

  # Пустой метод, но он существует. Когда вызывается,
  # ничего не делает.
  def left
  end

  # Тоже пустой метод.
  def up
  end

  def down
    self.y -= 1
  end

  # Как отображаем собаку.
  def label
    '@'
  end
end


# Класс "Командир", который будет командовать и двигать роботов
# и собаку. ЭТОТ КЛАСС ТОЧНО ТАКОЙ ЖЕ, КАК И В ПРЕДЫДУЩЕМ ПРИМЕРЕ.
class Commander 
  # Дать команду на движение объекта. Метод принимает объект
  # и посылает (send) ему случайную команду.
  def move(who)
    m = [:right, :left, :up, :down].sample
    who.send(m)
  end
end

# Создать объект командира,
# командир в этом варианте программы будет один
commander = Commander.new

# Массив из 10 роботов и...
arr = Array.new(10) {Robot.new}

# ...и одной собаки. Т.к. собака реализует точно такой же интерфейс,
# все объекты в массиве "как будто" одного типа.
arr.push(Dog.new(x: -12, y: 12))

# В бесконечном цикле (для остановки программы нажать ^C)
loop do
  # Хитрый способ очистить экран
  puts "\e[H\e[2J"

  # Рисуем воображаемую сетку. Сетка начинается от -12 до 12 по X,
  # и от 12 до -12 по Y
  (12).downto(-12) do |y|
    (-12).upto(12) do |x|
      # Проверяем, есть ли у нас в массиве робот с координатами x и y
      # Заменили "any?" на "find" и записали результат в переменную
      somebody = arr.find { |somebody| somebody.x == x && somebody.y == y}
      # Если кто-то найден, рисуем label, иначе точку.
      if somebody
        # Вот ОН, ПОЛИМОРФИЗМ!
        # Рисуем что-то, "*" или "@", но что это - мы не знаем!
        print somebody.label
      else
        print '.'
      end
    end

    # Просто переводим строку:
    puts
end

# Проверка столкновения. Если есть два объекта с одинаковыми
# координатами и их "label" не равны, то значит робот поймал собаку.
game_over = arr.combination(2).any? do |a, b|
  a.x == b.x && \
  a.y == b.y && \
  a.label != b.label
end

if game_over
  puts 'Game over!'
  #exit
end

# Каждый объект двигаем в случайном направлении
arr.each do |somebody|
  # Вызываем метод move, все то же самое, что и в предыдущем
  # варианте. Командир не знает кому он отдает приказ.
  commander.move(somebody)
end

# Задержка в полсекунды
sleep 0.5
end


