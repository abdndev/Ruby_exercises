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
# Символы
# Чаще всего символы применяются для определения атрибутов класса:
class MyClass
  attr_reader :alpha, :beat
  attr_writer :gamma, :delta
  attr_accessor :epsilon
  # ...
end
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

# метод scan многократно просматривает строку в поисках указанного образца
# будучи вызван внутри блока, он возвращает массив
# если образец содержит несколько (заключенных в скобки) групп, то массив окажется вложенным
str1 = "abracadabra"
sub1 = str1.scan(/a./)
# sub1 теперь рано ["ab","ac","ad","ab"]
str2 = "Acapulco, Mexico"
sub2 = str2.scan(/(.)(c.)/)
# sub2 теперь равно [ ["A", "ca"], ["l", "co"], ["i", "co"]]

# если при вызове задан блок, то метод поочередно передает этому блоку найденные значения
str3 = "Kobayashi"
str3.scan(/[^aeiou]+[aeiou]/) do |x|
  print "Слог: #{x}\n"
end
# код выше выведет такой результат:
Слог: Ko 
Слог: ba 
Слог: ya 
Слог: shi 
-------------------------------------------------------------------------------
# Преобразование символов в коды ASCII и обратно
# одиночные символы в Ruby возвращаются в виде односимвольных строк:
str = "Martin"
print str[0]          # "M"

# В классе Integer имеется метод chr, который преобразует целое число в символ
# в классе String имеется метод ord, выполняющий противоположное действие.
str = 77.chr          # "M"
s2 = 233.chr("UTF-8") # "e"
num = "M".ord         # 77

-------------------------------------------------------------------------------
# Удаление хвостовых символов новой строки и прочих
# Метод chop удаляет последний символ строки (\n) и символ перевода каретки (\r) если он стоит перед ним.
str = gets.chop            # Прочитать, удалить символ новой строки
s2 = "Some string\n"       # "Some string" (нет символа новой строки)
s3 = s2.chop!              # s2 теперь тоже равно "Some string"
s4 = "Other string\r\n"    
s4.chop!                   # "Other string" (нет символа новой строки)
# при вызове варианта chop! операнд-источник модифицируется

# важно отметить, что при использовании метода chop последний символ удаляется даже если это не символ новой строки
str = "abcxyz"
s1 = str.chop              # "abcxy"

# поскольку символ новой строки присутствует не всегда, иногда удобнее применять метод chomp
str = "abcxyz"
str2 = "123\n"
str3 = "123\r"
str4 = "123\r\n"
s1 = str.chomp             # "abcxyz"
s2 = str2.chomp            # "123"
# если установлен стандартный разделитель записей, то удаляется не только \n, но также \r и \r\n
s3 = str3.chopm            # "123"
s4 = str4.chomp            # "123"

# если методу chomp передана строка-параметр, то удаляются перечисленные в ней символы, а не подразумеваемый по умолчанию разделитель записей
str1 = "abcxyz"
str2 = "abcxyz"
s1 = str1.chomp("yz")      # "abcx"
# кстати, если разделитель записей встречается в середине строки, то он удаляется:
s2 = str2.chomp("x")       # "abcxyz"
-----------------------------------------------------------------------------------
# Убирание лишних пропусков (пробелов, символов табуляции и перехода на новую строку)
# Метод strip удаляет пропуски в начале и в конце строки, а вариант strip! делает то же самое "на месте"
str1 = "\t \nabc \t\n"
str2 = str1.strip          # "abc"
str3 = str1.strip!         # "abc"
# str1 теперь тоже равно "abc"

# чтобы удалить пропуски только в начале или только в конце строки, применяются методы lstrip и rstrip
str = " abc "
s2 = str.lstrip            # "abc "
s3 = str.rstrip            # " abc"
# имеются также варианты lstrip! и rstrip! для удаления "на месте".
-----------------------------------------------------------------------------------
# Повтор строк
# Если строку умножить на n, то получится строка, состоящая из n конкатенированных копий исходной:
etc = "Etc. " * 3          # "Etc. Etc. Etc. "
ruler = "+" + ("." * 4 + "5" + "." * 4 + "+") * 3
# "+....5....+....5....+....5....+"
-----------------------------------------------------------------------------------
# Включение выражений в строку с помощью синтаксической конструкции #{}
# Нет нужды думать о преобразовании, добавлении и конкатенации, нужно лишь интерполировать переменную или выражение в любое место строки:
puts "#{temp_f} по Фаренгейту равно #{temp_c} по Цельсию"
puts "Значение определителя равно #{b*b - 4*a*c}."
puts "#{word} это #{word.reverse} наоборот"

# Внутри фигурных скобок могут находиться даже полные предложения. При этом возвращается результат вычисления последнего выражения
str = "Ответ равен #{ def factorial(n)
                        n == ? 1 : n*factorial(n-1)
                      end

                      answer = factorial(3) * 7}, of course."
# Ответ равен 42, естественно.

# При интерполяции глобальных переменных, а также переменных класса и экземпляра фигурные скобки можно опускать:
puts "$gvar = #$gvar и ivar = #@ivar."
----------------------------------------------------------------------------------
# Возведение в степень обозначается оператором **, эта операция подчиняется обычным математическим правилам.
a = 64**2          # 4096
b = 64**0.5        # 8.0
c = 64**0          # 1
d = 64**-1         # 0.015625

# При делении одного целого числа на другое в Ruby дробная часть отбрасывается
# если один и операндов с плавающей точкой, то результат также будет с плавающей точкой
3 / 3              # 1
5 / 3              # 1
3 / 4              # 0
3.0 / 4            # 0.75
3 / 4.0            # 0.75
3.0 / 4.0          # 0.75

# Если вы работаете с переменными и сомневаетесь относительно их типа, воспользуйтесь приведением типа к Float или методом to_f:
z = x.to_f / y
z = Float(x) / y
-----------------------------------------------------------------------------------------------
# Округление чисел с плавающей точкой
# Метод round округляет число с плавающей точкой до целого:
pi = 3.14159
new_pi = pi.round        # 3
temp = -47.6
temp2 = temp.round       # -48

# В случае, когда надо округлить не до целого, а до заданного числа знаков после запятой, можно воспользоваться
# функциями sprintf (которая умеет округлять) и eval
pi = 3.1415926535
pi6 = eval (sprintf("%8.6f",pi))       # 3.141593
pi5 = eval (sprintf("%8.5f",pi))       # 3.14159
pi4 = eval (sprintf("%8.4f",pi))       # 3.1416
# Это не слишком красиво. Поэтому инкапсулируем оба вызова функций в метод, который добавим в класс Float:
class Float

  def roundf(places)
    temp = self.to_s.length
    sprintf("%#{temp}.#{places}f",self).to_f
  end

end
--------------------------------------------------------------------------------------
# Диапазоны
# Открытые и замкнутые диапазоны
# Диапазон называют замкнутым, если он включает конечную точку и открытым, в противном случае
r1 = 3..6       # замкнутый
r2 = 3...6      # открытый
a1 = r1.to_a    # [3,4,5,6]
a2 = r2.to_a    # [3,4,5]
# нельзя сконструировать диапазон, который не включал бы начальную точку. Можно считать это ограничением языка Ruby.

# Нахождение границ диапазона
# Методы first и last возвращают соответственно левую и правую границу диапазона. У них есть синонимы begin и end
r1 = 3..6
r2 = 3...6
r1a, r1b = r1.first, r1.last        # 3, 6
r1c, r1d = r1.begin, r1.end         # 3, 6
r2a, r2b = r1.begin, r1.end         # 3, 6

# метод exclude_end? сообщает, включена ли в диапазон конечная точка:
r1.exclude_end?   # false
r2.exclude_end?   # true

# обход диапазона:
(3..6).each { |x| puts x}           # печатаются четыре строки
                                    # скобки обязательны
# Проверка принадлежности к диапазону
r1 = 23456..34567
x = 14142
y = 31416
r1.include?(x)              # false
r1.include?(y)              # true
# у этого метода есть также синоним member?

# Преобразование в массив
r = 3..12
arr = r.to_a    # [3,4,5,6,7,8,9,10,11,12]

# Обратные диапазоны
r = 6..3
x = r.begin                 # 6
y = r.end                   # 3
flag = r.end_excluded?      # false
------------------------------------------------------------------------------------------
# Определение текущего момента времени
t0 = Time.new 
# Синонимом служит Time.now
t0 = Time.now

------------------------------------------------------------------------------------------
# Определение дня недели
# Способ с методом to_a. Можно обратиться к седьмому элементу массива (от 0 до 6), который соответствует дню недели (0 - воскресенье, а 6 - суббота)
time = Time.now
day = time.to_a[6]          # 2 (вторник)
# Еще лучше воспользоваться методом экземпляра wday:
day = time.wday             # 2 (вторник)
# Но оба вышеописанные методы не очень удобны. Есть еще один метод - strftime, который распознает около 20 спецификаторов
# позволяя по-разному форматировать дату и время
day = time.strftime("%A")        # "Tuesday"
# можно получить и сокращенное название
tln = time.strftime("%a")       # "Tue"
