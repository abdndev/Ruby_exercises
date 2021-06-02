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

  x = total_weight(soccer_ball_count: 3, tennis_ball_count: 2)
  puts x
--------------------------------------------------------------------------------
# пример применения метода initialize

class Car 
  def initialize
    puts 'hello from constructor!'
  end
end

car1 = Car.new

-------------------------------------------------------------------------------
# пример конструктора в JS
class Car {
  constructor() {
    console.log('hello from constructor!');
  }
}

let car1 = new Car();
-------------------------------------------------------------------------------
# пример тестов rspec: файл shipment_spec.rb

require './lib/shipment'                        # подключаем юнит
                                                # специальный синтаксис, который дословно говорит:
describe Shipment do                            # "описываем Shipment (отправление)"
  it 'should work without options' do           # специальный синтаксис, который дословно говорит: "это должно работать без опций". То что в кавычках - это строка, мы сами её пишем, слово "it" служебное.
    expect(Shipment.total_weight).to eq(29)     # ожидаем, что общий вес отправления будет равен 29 (eq от англ. "equal")
  end

  it 'should calculate shipment with only one item' do    # пример теста проверки для только одной вещи каждого вида в корзине
    expect(Shipment.total_weight(soccer_ball_count: 1)).to eq(410 + 29)
    expect(Shipment.total_weight(tennis_ball_count: 1)).to eq(58 + 29)
    expect(Shipment.total_weight(golf_ball_count: 1)).to eq(45 + 29)
  end

  it 'should calculate shipment with multiple items' do # пример теста проверки для нескольких вещей в корзине
    expect(
      Shipment.total_weight(soccer_ball_count: 3, tennis_ball_count: 2, golf_ball_count: 1)
    ).to eq(1420)
  end
end
-----------------------------------------------------------------------------------------------------------------
# использование eval
str = '#{name} - моё имя, а #{nation} - моя страна.'
name, nation = "Стивен Дедал", "Ирландия"
s1 = eval('"' + str + '"')
--------------------------------------------------------------------------------------------
# использование proc
str = proc do |name, nation|
  "#{name} - моё имя, а #{nation} - моя страна."
end
s2 = str.call("Гулливер Фойл", "Терра")
--------------------------------------------------------------------------------------------
# применение символов
class SomeClass
  attr_accessor :whatever    # чтобы добавить в класс аттрибут, допускающий чтение и изменение
end
# это же можно выразить иначе
class SomeClass
  def whatever
    @whatever
  end
  def whatever=(val)
    @whatever = val 
  end
end
--------------------------------------------------------------------------------------------
# преобразование строки в символ и обратно с помощью методов to_str и to_sym
a = "foobar"
b = :foobar
a == b.to_str  # true
b == a.to_sym  # true
--------------------------------------------------------------------------------------------
# проверка принадлежности к диапазону с помощью метода include?
r1 = 23456..34567
x = 14142
y = 31416
r1.include?(x)  # false
r1.include?(y)  # true
--------------------------------------------------------------------------------------------
# преобразование диапазона в массив
r = 3..12
arr = r.to_a   # [3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
--------------------------------------------------------------------------------------------
# определение порядкового номера дня в году
t = Time.now
day = t.yday   # 146
--------------------------------------------------------------------------------------------
# как открывать файлы для чтениия и записи
file1 = File.new("one")         # Открыть для чтения
file2 = File.new("two", "w")    # Открыть для записи
-----------------------------------------------------------------------------
# закрытие файла с методом close
out = File.new("captains.log", "w")
  # обработка файла...
out.close
-----------------------------------------------------------------------------
# автоматическое закрытие файла с методом open
File.open("somefile", "w") do |file|
  file.puts "Строка 1"
  file.puts "Строка 2"
  file.puts "Третья и последняя строка"
end
# теперь файл закрыт
-----------------------------------------------------------------------------
# обновление файла
# чтобы открыть файл для чтения и записи, достаточно добавить знак (+) в строку задания режима
f1 = File.new("file1", "r+")
# Чтение/запись, от начала файла.

f2 = File.new("file2", "w+")
# Чтение/запись; усечь существующий файл или создать новый.

f3 = File.new("file3", "a+")
# Чтение/запись; перейти в конец существующего файла или создать новый.
------------------------------------------------------------------------------
<<<<<<< HEAD
# простейшее Rack-приложение на основе класса
class MyRackApp
  def call(env)
    [200, {'Content-type' => 'text/plain'}, ["Welcome to Rack!"]]
  end
end

# Предполагается приведенное выше определение
app = MyRackApp.new
run app
-----------------------------------------------------------------------------
=======
# определение размера массива с методами length и size
x = ["a", "b", "c", "d"]
a = x.length              # 4
b = x.size                # 4
------------------------------------------------------------------------------
# использование метода grep для сопоставления
a = %w[January February March April May]
a.grep(/ary/)       # ["January", "February"]
b = [1, 20, 5, 7, 13, 33, 15, 28]
b.grep(12..24)      # [20, 13, 15]
------------------------------------------------------------------------------
# Продолжение предыдущего примера...
# Будем сохранять длины строк
a.grep(/ary/) {|m| m.length}    # [7, 8]
# Будем сохранять квадраты исходных элементов
b.grep(12..24) {|n| n*n}        # {400, 169, 225}
------------------------------------------------------------------------------
# controlling Uppercase and Lowercase
s1 = "Boston Tea Party"
s2 = s1.downcase            # "boston tea party"
s3 = s2.upcase              # "BOSTON TEA PARTY"

# the capitalize method capitalizes the first character of a string while forcing all the remaining characters to lowercase
s4 = s1.capitalize          # "Boston tea party"
s5 = s2.capitalize          # "Boston tea party"
s6 = s3.capitalize          # "Boston tea party"

# the swapcase method exchanges the case of each letter in a string
s7 = "THIS IS AN ex-parrot."
s8 = s7.swapcase            # "this is an EX-PARROT."
-----------------------------------------------------------------------------
