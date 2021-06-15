Array.new(5) { Array.new(4) { rand(0..9) } } # Создать массив 5 на 4 и заполнить весь массив абсолютно случайными значениями от 0 до 9.


[11, 22, 33, 44, 55].count(&:even?)   # С помощью указателя на функцию посчитать количество четных элементов в массиве
[0, 0, 1, 1, 0, 0, 1, 0].count { |x| x == 0} # использование метода .count для вычисления количества нулевых значений в массиве. Метод .count может принимать блок.

arr = [ [30, 1], [25, 0], [64, 1], [64, 0], [33, 1] ] # первый элемент каждого подмассива - возраст, второй элемент - пол(муж - 1, жен - 0)
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
# Отложенная интерполяция
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
# Разбиение строки на лексемы. Метод split разбивает строку на части и возвращает массив лексем.
s1 = "Была темная грозовая ночь"
words = s1.split                    # ["Была", "темная", "грозовая", "ночь"]

s2 = "яблоки, груши, персики"
list = s2.split(", ")               # ["яблоки", "груши", "персики"]

s3 = "львы и тигры и медведи"
zoo = s3.split(/ и /)             # ["львы", "тигры", "медведи"]
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
# конкатенация строк с оператором <<
str = "A"
str << [1, 2, 3].to_s << " " << (3.14).to_s
# str теперь равно "A123 3.14"
-----------------------------------------------------------------------------

# получение длины строки
str1 = "Карл"
x = str1.length   # 4
str2 = "Дойль"
x = str2.size     # 5
-----------------------------------------------------------------------------
# Построчная обработка
str = "Когда-то\nдавным-давно...\nКонец\n"
num = 0
str.each_line do |line|
    num += 1
    print "Строка #{num}: #{line}"
end

# результат...
# Строка 1: Когда-то
# Строка 2: давным-давно...
# Строка 3: Конец
-----------------------------------------------------------------------------
# побайтовая обработка
str = "ABC"
str.each_byte { |byte| print byte, " "}
puts
# результат 65 66 67
-----------------------------------------------------------------------------
# подсчет числа определенных символов в строке
s1 = "abracadabra"
a = s1.count("c")     # 1
b = s1.count("bdr")   # 5

c = s1.count("^a")    # 6
d = s1.count("^bdr")  # 6

e = s1.count("a-d")   # 9
f = s1.count("^a-d")  # 2
-----------------------------------------------------------------------------
# обращение строки
s1 = "Star Trek"
s2 = s1.reverse          # "kerT ratS"
s1.reverse!              # s1 теперь равно "kerT ratS"

# обращение порядка слов, а не символов
phrase = "Now here's a sentence"
phrase.split(" ").reverse.join(" ")   # "sentence a here's Now"
-----------------------------------------------------------------------------
# Удаление дубликатов. Цепочки повторящихся символов можно сжать до одного методом squeeze
s1 = "bookkeeper"
s2 = s1.squeeze      # "bokeper"
s3 = "Hello..."
s4 = s3.squeeze      # "Helo."
# Если указан параметр, то будут удаляться только дубликаты заданных в нем символов
s5 = s3.squeeze(".") # "Hello."
-----------------------------------------------------------------------------
# Удаление заданных символов
s1 = "To be, or not to be"
s2 = s1.delete("b")           # "To e, or not to e"
s3 = "Veni, vidi, vici!"      
s4 = s3.delete(",!")          # "Veni vidi vici"
-----------------------------------------------------------------------------
# Generating Successive Strings Генерирование последовательности строк
droid = "R2D2"
improved = droid.succ            # "R2D3"
pill = "Vitamin B"
pill2 = pill.succ                # "Vitamin C"
-----------------------------------------------------------------------------
# Вычленение и замена подстрок
str = "Шалтай-Болтай"
sub1 = str[7,4]                # "Болт"
sub2 = str[7,99]               # "Болтай" (выход за границу строки допускается)
sub3 = str[10,-4]              # nil (отрицательная длина)
# если индекс отрицательный, то отсчет ведется от конца строки (в этом случае индекс начинается с единицы, а не с нуля)
str1 = "Алиса"
sub1 = str1[-3, 3]             # "иса"
str2 = "В Зазеркалье"         
sub3 = str2[-8, 6]             # "зеркал"

# Можно задавать диапазон. Он интерпретируется как диапазон позиций внутри строки
str = "Уинстон Черчилль"
sub1 = str[8..13]       # "Черчил"
sub2 = str[-4..-1]      # "илль"
sub3 = str[-1..-4]      # nil
sub4 = str[25..30]      # nil

# Если задано регулярное выражение, то возвращается строка по образцу, если нет соответствия, то nil
str = "Alistair Cooke"
sub1 = str[/l..t/]      # "list"
sub2 = str[/s.*r/]      # "stair"
sub3 = str[/foo/]       # nil

# Если задана строка, то она и возвращается, если встречается в качестве подстроки в исходной строке, в противном случае возвращается nil
str = "theater"
sub1 = str['heat']      # "heat"
sub2 = str["eat"]       # "eat"
sub3 = str["ate"]       # "ate"
sub4 = str["beat"]      # nil
sub5 = str["cheat"]     # nil

str = "Aaron Burr"
ch1 = str[0]            # "A"
ch2 = str[1]            # "a"
ch3 = str[99]           # nil

# важно понимать, что все описанные выше способы могут использоваться не только для досупа к построке, но, и для ее замены
str1 = "Шалтай-Болтай"
str1[7,3] = "Хва"                         # "Шалтай-Хватай"

str2 = "Алиса"
str2[-3,3] = "ександра"                   # "Александра"

str3 = "В Зазеркалье"
str3[-9, 9] = "стеколье"                  # "В Застеколье"

str4 = "Уинстон Черчилль"
str4[8..11] = "Х"                         # "Уинстон Хилль"

str5 = "Alistair Cooke"
str[/e$/] = "ie Monster"                  # "Alistair Cookie Monster"

str6 = "theater"
str6["er"] = "re"                         # "theatre"

str7 = "Aaron Burr"
str7[0] = "B"                             # "Baron Burr"
# присваивание выражения, равного nil, не оказывает никакого действия

------------------------------------------------------------------------------
# метод sub заменяет первое вхождение строки, соответствующей образцу другой строкой или результатом вычисления блока
s1 = "spam, spam, and eggs"
s2 = s1.sub(/spam/, "bacon")
# "bacon, spam, and eggs"

s3 = s2.sub(/(\w+), (\w+),/,'\2, \1,')
# "spam, bacon, and eggs"

s4 = "Don't forget the spam."
s5 = s4.sub(/spam/) { |m| m.reverse }
# "Don't forget the maps"

s4.sub!(/spam/) { |m| m.reverse }
# s4 is now "Don't forget the maps."

# метод gsub (глобальная подстановка) отличается от sub тем, что заменяет все вхождения, а не только первое
s5 = "alfalfa abracadabra"
s6 = s5.gsub(/a[bl]/, "xx")        # "xxfxxfa xxracadxxra"
s5.gsub!(/[lfdbr]/) { |m| m.upcase + "-" }
# s5 теперь равно "aL-F-aL-F-a aB-R-acaD-aB-R-a"
-----------------------------------------------------------------------------
# поиск в строке
# метод index возвращает начальную позицию заданной построки, символа или регулярного выражения
str = "Albert Einstein"
pos1 = str.index(?E)            # 7
pos2 = str.index("bert")        # 2
pos3 = str.index(/in/)          # 8
pos4 = str.index(?W)            # nil
pos5 = str.index("bart")        # nil
pos6 = str.index(/wein/)        # nil

# метод rindex начинает поиск с конца строки, но, номера позиций отсчитываются, тем не менее, от начала
str = "Albert Einstein"
pos1 = str.rindex(?E)          # 7
pos2 = str.rindex("bert")      # 2
pos3 = str.rindex(/in/)        # 13 (найдено самое правое соответствие)
pos4 = str.rindex(?W)          # nil
pos5 = str.rindex("bart")      # nil
pos6 = str.rindex(/wein/)      # nil

# метод include? сообщает, встречается ли в данной строке указанная подстрока или один символ

str1 = "mathematics"
flag1 = str1.include? ?e       # true
flag2 = str1.include? "math"   # true
str2 = "Daylight Saving Time"
flag3 = str2.include? ?s       # false
flag4 = str2.include? "Savings" # false




