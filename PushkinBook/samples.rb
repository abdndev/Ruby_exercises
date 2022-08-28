# Создание новостных лент
# Есть также возможность генерировать документы в формате RSS или Atom с помощью
# метода RSS::Maker из стандартной библиотеки RSS. В примере ниже создается
# небольшая лента в формате Atom для гипотетического сайта:
require 'rss'

feed = RSS::Maker.make("atom") do |f|
  f.channel.title = "Feed Your Head"
  f.channel.id = "https://nosuchplace.org/home/"
  f.channel.author = "Y.T."
  f.channel.logo = "https://nosuchplace.org/images/headshot.jpg"
  f.channel.updated = Time.now 


  f.items.new_item do |i|
    i.title = "Once again, here we are"
    i.link = "https://nosuchplace.org/articles/once_again"
    i.description = "Don't you feel more like you do now than usual?"
    i.updated = Time.parse("2014-08-17 10:23AM")
end

# Объект Maker создается в инициализаторе блока, подобном обсуждавшемуся
# в разделе "ООП и динамические механизмы в Ruby". В блоке мы устанавливаем
# атрибуты ленты title, id, author и временную метку updated - все они
# являются обязательными.
# Затем мы вызываем метод new_item, который создает новую статью и добавляет
# ее в ленту, снова с помощью блока. У каждой статьи должны быть атрибуты
# title, description(или summary), link (ссылка на URL, содержащий полный
# текст статьи) и updated (временная метка). Необязательный атрибут content
# позволяет включить полный текст непосредственно в статью.
# Стандартная библиотека RSS очеь неплоха, но есть и другие библиотеки
# для разбора и генерации новостных лент в форматах RSS и Atom.
# Если для ваших целей стандартной библиотеки недостаточно, зайдите на
# сайт ruby-toolbox.com или поищите в Интернете что-нибудь более подходящее.

# Создание документов в формате PDF с помощью библиотеки Prawn
# Формат Portable Document Forman (PDF), первоначально получивший известность благодаря программе
# Adobe Acrobat Reader, уже много лет полулярен. Он доказал свою полезность для распространения
# "готовых к печати" качественно отформатированных документов, независимых от программного обеспечения
# обработки текстов и операционной системы.
# В Ruby для создания PDF-документов чаще всего применяется библиотека Prawn, созданная Грегори Брауном
# и многими другими авторами. Мы рассмотрим, как работает Prawn, а затем воспользуемся ей для создания
# PDF-документа
# Основные концепцуи и приемы
# В основе Prawn лежит класс Prawn::Document, который позволяет создавать PDF-документы, применяя
# два или три стиля кодирования, например:
require "prawn"

doc = Prawn::Document.new            # Начать новый документ
doc.text "Lorem ipsum dolor..."      # Добавить текст
doc.render_file "my_first.pdf"       # Записать в файл
# Если задать параметр блока, то объект-генератор передается явно:
Prawn::Document.generate("ericblair.pdf") do |doc|
  doc.text "It was a bright cold day in April, "
  doc.text "and the clocks were striking thirteen."
end
# Эти формы по существу эквивалентны. Какую выбрать, зависит от личных предпочтений и удобства в конкретной
# ситуации.
# Теперь поговорим о страничных координатах. Начало кооординат в PDF находится в левом нижнем углу
# страницы, как принято в математике. Ограничивающий прямоугольник - это воображаемый прямоугольник
# внутри страницы. Существует один ограничивающий прямоугольник по умолчанию, который называется 
# граничным прямоугольником (margin box) и служит контейнером для всего, что находится на странице.
# Начальное положение курсора в Prawn находится в верхней части страницы, несмотря на то, что начало
# координат располагается внизу. При добавлении текста в документ курсор сдвигается (его можно сдвинуть
# и вручную с помощью таких методов, как move_cursor_to, move_up и move_down).
# Метод cursor возвращает текущую позицию курсора.
# "Стандартной " единицей измерения в Prawn  является пункт (1/72 дюйма).
# Загрузив пакет 'prawn/measurement_extensions', вы сможете использовать и другие единицы измерения.
# Prawn располагает большим набором процедур обработки текста, а также графическими примитивами для 
# рисования прямых и кривых линий и геометрических фигур.

# Пример документа
# Рассмотрим несколько искусственный пример. Программа, показанная ниже, делит страницу на четыре
# прямоугольника и каждый заполняет по разному.
require 'prawn'

# На основе кода, предложенного Брэдом Эдигером

class DemoDocument
  def initialize
    @pdf = Prawn::Document.new 
  end

  def render_file(file)
    render 
    @pdf.render_file(file)
  end 

  def render 
    side = @pdf.bounds.width / 2.0 
    box(0, 0, side, side) { star }
    box(side, 0, side, side) { heart }
    box(0, side, side, side) { ruby }
    box(side, side, side, side) { misc_text }
  end

  private
  
  # Выполнить указанный блок в ограничивающем прямоугольнике, отделенном
  # от родителя отступом размером 'padding' пунктов.
  def inset(padding)
    left = @pdf.bounds.left + padding 
    top = @pdf.bounds.top - padding
    @pdf.bounding_box([left, top],
      width: @pdf.bounds.width - 2*padding,
      height: @pdf.bounds.height - 2*padding) { yield }
  end

  # Нарисовать прямоугольник заданного размера с левым верхним углом в точке
  # (x, y) и вызвать yield, чтобы можно было выполнить в нем рисование.
  def box(x, y, w, h)
    @pdf.bounding_box([x, @pdf.bounds.top - y], width: w, height: h) do 
      @pdf.stroke_bounds
      inset(10) { yield }
    end
  end

  def star 
    reps = 15
    size = 0.24 * @pdf.bounds.width 
    radius = 0.26 * @pdf.bounds.width
    center_x = @pdf.bounds.width / 2.0
    center_y = @pdf.bounds.height / 2.0
    reps.tines do |i|
      @pdf.rotate i * 360.0 /reps, origin: [center_x, center_y] do 
        edge = center_y + radius 
        @pdf.draw_text ")", size: size, at: [center_x, edge]
      end
    end
  end
  
  def ruby 
    @pdf.image "ruby.png",
             at: [0, @pdf.cursor],
             width: @pdf.bounds.width,
             height: @pdf.bounds.height
  end

  def heart
    10.times do |i|
      inset(i * 10) do
        box = @pdf.bounds
        center = box.width / 2.0 
        cusp_y = 0.6 * box.top 

        k = center * Prawn::Graphics::KAPPA
        @pdf.stoke_color(0, 0, 0, 100-(i*10))
        @pdf.stroke do 
          # Нарисовать сердце, состоящее из двху кривых Безье
          paths = [[0, 0.9*center], [box.right, 1.1*center]]
          paths.each do |side, midside|
            @pdf.move_to [center,cusp_y]
            @pdf.curve_to [side, cusp_y],
              bounds: [[center, cusp_y + k], [side, cusp_y + k]]
            @pdf.curve_to [center, box.bottom],
              bounds: [[side, 0.6 * cusp_y], [midside, box.bottom]]
          end
        end
      end
    end

    # переустановить цвет обводки
    @pdf.stroke_color 0, 0, 0, 100
  end

  def misc_text
    first_lines = <<-EOF
      Call me Ishmael. Somewhere in la  Mancha, in a place whose
      name I do not care to remember, a gentleman lived not long
      ago, one of those who has a lance and ancient shield on a
      shelf and keeps a skinny nag and a greyhound for racing.
      The sky above the port was the color of television, tuned to
      a dead channel. I was a pleasure to burn. Granted: I am an
      inmate of a mental hospital; my keeper is watching me, he
      never lets me out of his sight; there's a peephole in the 
      door, and my keeper's eye is the shade of brown that can 
      never see through a blue-eyed type like me. Whether I shall
      turn out to be the hero of my own life, or whether that 
      station will be held by anybody else, these pages must show.
      I have never begun a novel with more misgiving.
      EOF
      first_lines.gsub!(/\n/, " ")
      first_lines.gsub!(/ +/, " ")
      @pdf.text first_lines
  end
end
DemoDocument.new.render_file("demo.pdf")
 
# В двух верхних квадратах демонстрируется API рисования. В левом верхнем 
# нарисована звездообразная фигура, состоящая из последовательности дуг
# одинакового радиуса, но с разными центрами. В правом верхнем мы видим
# более сложный рисунок сердца, составленного из кривых Безье.
# В левый нижний квадрант мы поместили PNG-изображение, воспользовавшись
# методом image. Наконец, в правом нижнем квадрате размещен текст, не выходящий
# за пределы ограничивающего прямоугольника.
# Но, это лишь малая толика возможностей Prawn API. Его полное описание можно
# найти в справочной документации по адресу: prawnpdf.org.

# API рисования
# В RMagick имеется развитый API для рисования линий, многоугольников и различных кривых. Он поддерживает
# заливку, полупрозрачность, задание цветов, выбор шрифтов, вращение, растяжение и другие операции.
# Полное описание этого API выходит за рамки книги, но чтобы получить представление об имеющихся
# возможностях, рассмотрим простой пример.
# В листинге 15.7 приведена программа, которая рисует на заданном фоне сетку, а поверх нее несколько
# закрашенных геометрических фигур. Черно-белое изображение, получившееся в результате, показано на рис.15.3
require 'rmagick'

img = Magick::ImageList.new
img.new_image(500, 500)

purplish = "#ff55ff"
yuck = "#5fff62"
bleah = "#3333ff"
line = Magick::Draw.new
50.step(450, 50) do |n|
  line>line(n,50, n,450)     # вертикальная прямая
  line.draw(img)
  line.line(50,n, 450,n)     # горизонтальная прямая
  line.draw(img)
end

# Тестирование с помощью RSpec
# В последние годы широкое распространение получила идея разработки, управляемой поведением (behavour-driven development
# BDD): спецификация поведения системы и есть естественная основа для тестирования.
# RSpec, плод трудов Дэвида Хелимски (David Chelimsky) и других, пожалуй, является самым употребительным каркасом BDD
# для Ruby. При его проектировании за образец была взята система JBehave для Java.
# Для иллюстрации этого и проччих каркасов тестирования возьмем показанный ниже фрагмент кода (надеюсь курс математики
# за 7 класс еще не полностью выветрился из вашей головы).
# Метод quadratic (мы поместили его в файл quadratic.rb) решает квадратное уравнение. Он принимает три коэффициента 
# квадратного трехчлена и возвращает массив, содержащий 0, 1 или два вещественных корня. В качестве дополнительной 
# функциональности мы включили еще четвертый параметр - булев флаг, показывающий, разрешены ли комплексные корни:
require 'complex'

def quadratic(a, b, c, complex=false)
  raise ArgumentError unless [a, b, c].all? {|x| Numeric === x }
  discr = b*b - 4*a*c 
  if (discr > 0) || (complex && discr < 0)
    val = Math.sqrt(discr)
    r1 = (-b + val)/(2*a.to_f)
    r2 = (-b - val)/(2*a.to_f)
    return [r1, r2]
  elsif discr.zero?
    r1 = -b/(2*a.to_f)
    return [r1]
  else                               # если complex равно false
    return []
  end

# Для тестирования этого метода мы соберем сравнительно простой набор тестов RSpec, которые будем прогонять с помощью
# gem-пакета rspec. Обычно эти тесты находятся в каталоге rspec, а имена файлов оканчиваются суффиксом _spec и имеют
# расширение .rb.
# Вообще говоря, один spec-файл тестирует какую-то часть функциональности. Как правило, такая часть соответствует
# одному классу, но может быть как меньше, так и больше класса.
# Типичный spec-файл имеет такой вид:
# spec/foobar_spec.rb
require 'foobar'

RSpec.describe Foobar do
  describe "some_method" do
    it "returns something when called" do 
      # Здесь должен быть тестовый код...
    end
  end
end
# Установив gem-пакет rspec, мы можем выполнить этот spec-файл, запустив исполнитель:
$ rspec spec/foobar_spec.rb
# Программа rspec читает параметры командной строки из файла .rspec. По умолчанию этот файл содержит только параметр 
# -require spec_helper. Файл spec/spec_helper.rb - это место для настройки RSpec, а также общего кода, который понадобится
# во время тестирования. Его наличие необязательно.
# Сам spec-файл должен затребовать класс или иной код, который предстоит протестировать. В наших примерах предполагается,
# что тестируемый код находится в каталоге lib. RSpec (или файл spec_helper) должен добавить каталог lib в переменную
# Ruby $LOAD_PATH, чтобы находящиеся там файлы можно было затребовать без указания полного пути, как в примере выше.
# Метод describe принимает параметр, который обычно является именем класса, но может быть и описательной строкой. 
# Блок содержит все тесты (и может также содержать вложенные блоки describe).

# Теперь обратимся к тестам метода решения квадратного уравнения. Содержимое файла quadratic_spec.rb показано ниже:
require 'quadratic'

describe "Quadratic equation solver" do
  it "can take integers as arguments" do 
    expect(quadratic(1, 2, 1)).to eq([-1.0])
  end

  it "can take floats as arguments" do 
    expect(quadratic(1.0, 2.0, 1.0)).to eq([-1.0])
  end

  it "returns an empty solution set when appropriate" do
    expect(quadratic(2, 3, 9)).to eq([])
  end

  it "honors the 'complex' Boolean argument" do 
    solution = quadratic(1, -2, 2, true)
    expect(solution).to eq([Complex(1.0,1.0), Complex(1.0,-1.0)])
  end

  it "raises ArgumentError when for non-numeric coefficients" do 
    expect { quadratic(3, 4, "foo") }.to raise_error(ArgumentError)
  end
end
# Любой тест представляет собой вызов метода it; она назван так для того, чтобы получалась иллюзия предложения на 
# английском языке, в котором "it" - подлежащее. Строковый параметр довершает эту иллюзию, а блок содержит код 
# соответствующего теста.
# Тест может содержать произвольный код, но обязательно должен включать хотя бы одно предложение, в котором производится
# проверка (технически оно называется выражением ожидания).
# Типичное выражение ожидания состоит из метода expect, ожидания и сопоставителя. Существует два метода ожиданияя:
# to и to_not.
# В самой распространенной форме такое выражение просто проверяет, что одно равно другому: expect(result).to eq(value).
# Сопоставителей существует много, и можно определять свои собственные. Ниже показаны наиболее употребительные (во всех 
# случаях результат равен true):
expect(5).to eq(5)
expect(5).to_not eq(6)
expect(5).to_not be_nil 
expect(5).to be_truthy
expect(5).to_not eq(false)
expect(nil).to be_nil
expect("").to be_empty             # "be_xxx" вызывает метод "xxx"
expect([]).to be_empty             # аргумента expect
expect([1,2,3]).to include(2)
expect([1,2]).to be_an(Array)
# Для тестирования исключений код следует поместить в блоок, который передается методу expect:
expect { x = 1 / 0 }.to raise_error
# Метод raise_error может принимать в качестве параметра класс исключения и строковое значение. Оба параметра необязательны,
# обычно сравнение со строкой считается перебором.
# RSpec этим отнюдь не ограничивается. Для более сложных тестов могут потребоваться методы before, after и let (для инициализации,
# очистки и прочих вещей). Эти и другие детали описаны в полном руководстве.
# Понятно, что под капотом RSpec вершится разного рода "черная магия". Если по каким-то причинам этот каркас вам не по вкусу, 
# присмотритесь к пакету minitest, основанному на более традиционном "автономном тестированиии".

# Тестирование с помощью Minitest
# Гем-пакет minitest, написанный Райаном Дэвисомм (Ryan Davis), позволяет тестировать Ruby-код в классическом 
# автономном стиле. Вполне возможно, что он уже входит в ваш дистрибутивв Ruby, а, если нет, установите его командой
# gem install minitest.
# В классе Minitest::Test применяется отражение для анализа тестового кода. В его подклассах все методы с именами,
# начинающимися строкой test, исполняются как тесты:
require 'minitest/autorun'

class TestMyThing < Minitest::Test
  
  def test_that_it_works
    # ...
  end

  def test_it_doesnt_do_the_wrong_thing
    # ...
  end

  # ...
end
# Категорически не рекомендуется и, пожалуй, даже неправильно при тестировании поведения опираться на порядок
# выполнения тестов. Не должно быть так, что тесты проходят, только если выполняются в том порядке, в каком написаны - 
# следите за этим. Minitest специально прогоняет тесты в случайном порядке при каждом запуске.
# Кроме того, былоо бы неплохо сопровождать каждый тест однострочным комментарием, в котором описывается его назначение,
# особенно если тест сложный или содержит скрытые тонкости. В общем случае, у каждого теста должна быть одна
# и только одна цель.
# Если для теста требуется определенная настройка окружения, то можно создать методы класса setup и teardown.
# Эти методы вызываются до и после каждого прогона каждого теста, хотя интуитивно это, возможно, и неочевидно.
# А если настройка занимает много времени? Было бы непрактично выполнять ее для каждого теста, но и поместить ее
# в первый тестовый метод тоже нельзя (потому то тесты прогоняются случайным образом). Чтобы произвести настройку
# только один раз, перед всеми тестами, можно поместить соответствующий код в тело класса, до тестовых методов (или
# даже после самого класса).
# А как быть, если требуется произвести очистку после выполнения всех тестов? "Самый лучший" способ - переопределить
# метод класса run, включив в него эту функциональность. И раз уж мы заговорили об этом, добавим метод класса, 
# выполняющий настройку до прогона тестов. См. пример ниже.
require 'minitest/autorun'

class MyTest < Minitest::Test 
  def self.setup 
    # ...
  end

  def self.teardown
    # ...
  end

  def self.run(*)
    self.setup
    super  # выполнить каждый тестовый метод, как обычно
    self.teardown
  end

  def setup
    # ...
  end

  def teardown
    # ...
  end

  def test_that_it_works
    # ...
  end

  def test_it_is_not_broker
    # ...
  end

  # ...
end

# Вряд ли вам придется прибегать к этой технике часто, но в тех случаях, когда это необходимо, она исключительно 
# полезна.
# Ну а что поместить внутрь каждого теста? Нужен какой-то способ определить, завершился тест успешно или неудачно.
# Для этого предусмотрены утверждения.
# Простейшее утверждение - метод assert. Его первый параметр - подлежащее проверке выражение, а необязательный второй
# параметр - сообщение. Если значением первого параметра является true(т.е. все, кроме false и nil), значит, все
# хорошо. В противном случае считается, что тест не прошел, и печатается сообщение (если оно было задано).
# Ниже приведены другие методы утверждения (в комментариях описано, для чего они нужны).
# Отметим, то "ожидаемое" значение всегда предшествует "фактическому"; это существенно, если вы пользуетесь сообщениями
# об ошибках, подразумеваемыми по умолчанию, и не хотите, чтобы их смысл был прямо противоположен реальному положению вещей:
assert_equal(expected, actual)                   # assert(expected == actual)
refute_equal(expected, actual)                   # assert(expected != actual)
assert_match(regex, string)                      # assert(regex =~ string)
refute_match(regex, string)                      # assert(regex !~ string)
assert_nil(object)                               # assert(object.nil?)
refute_nil(object)                               # assert(!object.nil?)
# Некоторые утверждения связаны с объектной ориентированностью (и для них существуют противоположные варианты, 
# начинающиеся словом refute - опровергать):
assert_instance_of(klass, obj)                   # assert(obj).instance_of? klass)
assert_kind_of(klass, obj)                       # assert(obj).kind_of? klass)
assert_respond_to(obj, meth)                     # assert(obj.respond_to? meth)
# Некоторые методы относятся к исключениям и символам, обозначающим возбуждаемое исключение. У них нет варианта
# refute, потому то если предложения throw и raise не встречались, то код просто выполняется, как обычно.
# Поскольку если эти предложения все же встречаются, то код не может выполняться, как обычно, оба метода принимают блок:
assert_throws(symbol) { ... }                    # проверяет, что возбуждено исключение,
                                                 # обозначаемое указанным символом
assert_raises(exception) { ... }                 # проверяет, что возбуждено исключение
# Для коллекций и других объектов типа Enumerable определено несколько специальных методов:
assert_empty(coll)                               # assert(coll.empty?)
assert_includes(coll, obj)                       # assert(coll.includes?(obj))
# Есть и другие, но этих хватает для большинства потребностей. Дополнительные сведения смотрите в онлайновой документации
# по Minitest.
# Существует также метод flunk, который всегда завершается неудачно. Это просто заглушка для еще ненаписанных тестов.
# Вооружившись знаниями об утверждениях, протестируем наш метод решения квадратных уравнений. Тестовые файлы поместим
# в каталог test. Соглашение об именовании аналогично используемому в RSpec: имя файла должно завершаться строкой _test.rb
require 'minitest/autorun'
require 'quadratic'   

class QuadraticTest < MiniTest::Unit::TestCase
  def test_integers
    assert_equal [-1], quadratic(1, 2, 1)
  end

  def test_floats
    assert_equal [-1.0], quadratic(1.0, 2.0, 1.0)
  end
  def test_no_real_solutions
    assert_equal quadratic(2, 3, 9), []
  end

  def test_complex_solutions
    actual = quadratic(1, -2, 2, true)
    assert_equal actual, [Complex(1.0, 1.0), Complex(1.0, -1.0)]
  end

  def test_bad_args
    assert_raises(ArgumentError) { quadratic(3, 4, "foo") }
  end
end

# Если запустить тестовый файл, не предпринимая никаких специальных мер, то по умолчанию будет выполнен консольный
# исполнитель тестов, подразумеваемый по умолчанию. Это вызовет ностальгическое воспоминание о старой доброй технологии
# 1970-х годов - Minitest выводит сообщение такого вида:
Run options: -seed 7759

# Running tests:


Finished tests in 0.000702s, 7122.5071 tests/s,
       7122.5071 assertions/s.

5 tests, 5 assertions, 0 failures, 0 errors, 0 skips
# Если вы поклонник RSpec, то Minitest можно использовать аналогично. Основое отличие заключается в том, что 
# в RSpec применяется форма expect(subject).to something, а в Minitest - более прямолинейная форма subject.must_something.
# Пример ниже.
require 'minitest/autorun'
require 'quadratic'

describe "Quadratic equation solver" do 
  it "can take integers as arguments" do
    quadratic(1, 2, 1).must_equal([-1.0])
  end

  it "can take fleats as arguments" do
    quadratic(1.0, 2.0, 1.0).must_equal([-1.0])
  end

  it "returns an empty solution set when appropriate" do
    quadratic(2, 3, 9).must_equal([])
  end

  it "honors the 'complex' Boolean argument" do
    actual = quadratic(1, -2, 2, true)
    expected = [Complex(1.0,1.0), Complex(1.0,-1.0)]
    actual.must_equal expected
  end

  it "raises ArgumentError when for non-numeric coefficients" do 
    lambda { quadratic(3, 4 "foo") }.must_raise ArgumentError
  end
end
# Прогон этих тестов в стиле спецификаций дает те же результаты, что и в предыдущем случае.
# Помимо всего вышеизложенного, существуют десятки решений Minitest, которые добавляют или изменяют функциональность.
# Некоторые из них описаны в прилагаемом к Minitest файле readme, другие можете поискать на сайте Rubygems.org или GitHub.

# Тестирование с помощью Cucumber
# Cucumber - еще один каркас для BDD-тестирования. В нем используется очень простой и гибкий "язык", или нотация
# под названием Gherkin, близкий к разговорному английскому.
# В каких ситуациях использовать Cucumber, дело вкуса. Он увеличивает накладные расходы и требует дополнительного
# сопровождения тестов, зато объясняет, что именно тестируется, на языке, понятном заказчикам или руководителям,
# не имеющим технической подготовки. Идеальный случай - когда в написании спецификаций принимают участие стороны,
# не обремененные техническими познаниями.
# В других случаях, особенно когда все участниии технически подкованы, гораздо проще писать тесты (включая интеграционные
# и приемочные) прямо в виде кода. Вряд ли пример решения квадратного уравнения здесь уместен, но все же рассмотрим его.
# Для начала создадим каталог features и в нем подкаталог step_definitions. В каталоге features может находиться
# много файлов, ниже показан один из них - файл first.feature.
Feature: Check all behaviors of the quadratic equation solver

Scenario: Real roots 
  Given coefficients that should yield one real root 
  Then the solver returns an array of one Float r1
  And r1 is a valid solution.

  Given coefficients that should yield two real roots
  Than the solver returns an array of two Floats, r1 and r2 
  And r1 and r2 are both valid solutions.

Scenario: No real roots, and complex flag is off 
  Given coefficients that should yield no real roots
  And the complex flag is missing or false
  Then the solver returns an empty array.

Scenario: No real roots, and complex flag is on 
  Given coefficients that should yield no real roots 
  And the complex flag is true 
  Then the solver returns an array of two complex roots, r1 and r2 
  And r1 and r2 are both valid solutions.
# Если теперь запустить Cucumber, то он сделает разумную и полезную вещь: создаст "заготовку", которой можно 
# можно воспользоваться для написания определений шагов, т.е. реализаций на Ruby тестов, описанных в виде
# спецификации на английском языке. Эту заготовку можно скопировать в файл (в данном случае step_defenitions/first.rb)
# и модифицировать его по ходу дела. Тесты помечены признаком pending, чтобы они не "падали" из-за того, что код
# еще не написан.
# Вот пример созданной заготовки:
Given(/^coefficients that should yield one real root$/) do 
  pending # express the regexp above with the code you wish you had 
end

Then(/^the solver returns an array of one Float r(\d+)$/) do |arg1| 
  pending # express the regexp above with the code you wish you had
end

Then(/^\d+) is a valid solution\.$/) do |arg1|
  pending # express the regexp aboe with the code you wish you had
end
# Обратите внимание на то, как используются регулярные выражения, чтобы связать англоязычную фразу (на языке Gherkin)
# с соответствующим Ruby-кодом.
# Ниже показано, как я наполнил эту заготовку реальным кодом (в файле first.rb):
Given(/^coefficients that should yield one real root$/) do
  @result = quadratic(1, 2, 1)
end

Then(^the solver returns an array of one Float r(\d+)$/) do |arg1|
  expect(@resust.size).to_eq(1)
  expect(@result.first).to be_a(Float)
end

Then(/^r(\d+) is a valid solution\.$/) do |arg1|
  expect(@result).to eq([-1.0])
end
# Теперь эти три простеньких теста проходят. Написав аналогичным образом определения остальных шагов, мы получим
# спецификацию, которая, с одной стороны, написана на понятном английском языке, а с другой, пригодна для проверки
# правильности кода.
# Cucumber - очень мощная система, обладающая множеством полезных функций. 

# Объекты форматированной печати
# Метод inspect (и вызывающий его метод p) предназначен для вывода объектов в виде, понятном человеку. В этом смысле
# он является связующим звеном между тестированием и отладкой, поэтому рассмотрение его в этой главе оправдано.
# Проблема в том, что результат, формируемый методом p, бывает трудно читать. Из-за этого и появилась библиотека pp,
# добавляющая одноименный метод.
# Рассмотрим следующий искусственный пример объекта my_obj:
class MyClass 
  attr_accessor :alpha, :beta, :gamma 

  def initialize(a, b, c)
    @alpha, @beta, @gamma = a, b, c 
  end

end

x = MyClass.new(2, 3, 4)
y = MyClass.new(5, 6, 7)
z = MyClass.new(7, 8, 9)

my_ojb = { x => y, z => [:p, :q]}

p my_obj 
# Вызов метода p печатает следующее:
{#<MyClass:0xb7eed86c @beta=3, @alpha=2,
 @gamma=4>=>#<MyClass:0xb7eed72c @beta=6, @alpha=5, @gamma=7>,
 #<MyClass:0xb7eed704 @beta=8, @alpha=7, @gamma=9>=>[:p, :q]}

 # Все правильно и в общем-то даже читаемо. Но, не красиво. А давайте попробуем библиотеку pp и воспользуемся
 # предоставляемым ею методом pp:
 require 'pp'

 # ...

 pp my_obj
 # Теперь вывод приобретает такой вид:
 {#<MyClass:0xb7f7a050 @alpha=7, @beta=8, @gamma=9>=>[:p, :q],
  #<MyClass:0xb7f7a1b8 @alpha=2, @beta=3, @gamma=4>=>
   #<MyClass:0xb7f7a078 @alpha=5, @beta=6, @gamma=7>}
# Мы получили хотя бы пробелы и разбиение на строки. Уже лучше. Но можно пойти еще дальше. Предположим, что в классе
# MyClass определен специальный метод pretty_print:
class MyClass

  def pretty_print(printer)
    printer.text "MyClass(#@alpha, #@beta, #@gamma)"
  end

end
# Аргумент printer передается вызываеющей программой (или методом pp). Это аккумулятор текста, являющийся экземпляром
# класса PP; мы вызываем его метод text и передаем ему текстовое представление self. Вот что получается в результате:
{MyClass(7, 8, 9)=>[:p, :q], MyClass(2, 3, 4)=>MyClass(5, 6, 7)}
# Разумеется, можно настроить поведение по своему вкусу. Можно, например, печатать переменные экземпляра на разных
# строчках с отступами. 
# На самом деле, в библиотеке pp есть много средств для подготовки ваших классов к совместной работе с методом pp.
# Методы object_group, seplist, breakable и прочие позволяют управлять расстановкой запятых, разбиением на строки 
# и другими методами форматирования. Дополнительную информацию можно найти в документации по pp.

# Самая популярная библиотека для отладки программ на Ruby - gem-пакет byebug.
# Он реализован на основе механизма TracePoint, рассмотренного в разделе 11.4.4 главы 11 "ООП и динамические механизмы
# в Ruby". В версиях Ruby младше 2.0 аналогичную функциональность предлагал gem-пакет debugger.
# Честно говоря, применение отладчиков самих по себе мало то дает в Ruby. Лично я использую Byebug посредством 
# инструмента pry, который мы рассмотрим в следующем разделе. Но, давайте сначала поглядим, как работать с отладчиком,
# а затем уже перейдем к Pry и имеющимся в нем дополнительным возможнстям.
# Чтобы запустить Byebug, просто введите в командной строке слово byebug вместо ruby:
byebug myfile.rb
# Получив приглашене (byebug), можно вводить команды, например, step для входа внутрь метода, list для печати текста
# всей программы или ее части и т.д. Ниже перечислены наиболее употребительные команды:
* continue (c) - продолжить выполнение до указанной точки;
* break(b) - поставить точку останова или полуить их список;
* delete - удалить некоторые или все точки останова;
* catch - поставить точку перехвата или получить их список;
* step(s) - войти внутрь метода;
* next(n) - дойти до следующей строки (выполнить метод без захода внутрь);
* where(w) - напечатать трассировку текущего состояния стека;
* help(h) - получить справку (напечатать список команд);
* quit(q) - выйти из отладчика.
# В листинге ниже приведен код простой программы.
STDOUT.sync = true

def palindrome?(word)
  word == word.reverse
end

def signature(w)
  w.split("").sort.join
end

def anagrams?(w1, w2)
  signature(w1) == signature(w2)
end

print "Введите слово: "
w1 = gets.chomp

print "Введите еще одно слово:"
w2 = gets.chomp

verb = palindrome?(w1) ? "является" : "не является"
puts "'#{w1}' #{verb} палиндромом."

verb = palindrome?(w2) ? "является": "не является"
puts "'#{w2}' #{verb} палиндромом."

verb = anagrams?(w1, w2) ? "являются" : "не являются"
puts "'{w1}' и '{w2}' #{verb} анаграммами."

# В листинге ниже показан весь сеанс отладки, хотя некоторые строки программы ради краткости опущены. Читая распечатку,
# помните, что консоль используется как для отладки, так и для ввода-вывода.
$ byebug simple.rb

[1, 10] in simple.rb
=> 1: STDOUT.sync = true 

(byebug)  b Objects#palindrome?
Created breakpoint 1 at Object::palindrome?
(byebug) b Object#anagrams?
Created breakpoint 2 at Object::anagrams?
(byebug) info begin
Num Enb What 
1 y at Object:palindrome?
2 y at Object:anagrams?
(byebug) c 16
Введите слово:
Stopped by breakpoint 3 at simple.rb:16

[11, 20] in simple.rb
   15:      print "Введите слово: "
=> 16:      w1 = gets.chomp 
(byebug) c 19
live 
Введите еще одно слово:
[14, 23] in simple.rb
   18:     print "Введите еще одно слово: "
=> 19:     w2 = gets.chomp 

(byebug) n 
evil

[16, 25] in simple.rb 
=> 21:     verb = palindrome?(w1) ? "является" : "не является"
   22:     puts "'#{w1}' #{verb}  палиндромом." 

(byebug) c
Stopped by breakpoint 1 at Object:palindrome?

[1, 10] in simple.rb
=> 3:     def palindrome?(word)
   4:       word == word.reverse 

(byebug)

[1, 10] in simple.rb
   3:      def palindrome?(word)
=> 4:        word == word.reverse
   5:      end

(byebug)
Next went up a frame because previous frame finished

[17, 26] in simple.rb
    21:    verb = palindrome?(w1) ? "является" : "не является"
=>  22:    puts "'#{w1}' #{verb} палиндромом."

(byebug) c
'live' не является палиндромом.
'evil' не является палиндромом.

Stopped by breakpoint 2 at Object:anagrams?

[6, 15] in simple.rb
=> 11:     def anagrams?(w1, w2)
   12:       signature(w1) == signature(w2)
   13:     end

(byebug) c
'live' и 'evil' являются анаграммами.
# Отметим, что последнюю команду можно повторить, просто нажав клавишу Enter. Имейте ввиду, что если программа,
# исполняемая под управлением отладчика, затребует библиотеки, то в начале, возможно, придется "перешагнуть"
# довольно много предложений. Я рекомендую сразу перейти к интересующей вас строке, указав в команде continue ее номер.
# Отладчик распознает еще много команд. Можно распечатать стек вызовов и перемещаться по нему в обоих направлениях. 
# Можно "наблюдать" за выражением и автоматически останавливать программу, когда его значение изменяется. 
# Можно добавлять выражения в список "показа". Можно отлаживать многопоточную программу и переключаться между потоками.
# Все эти возможности довольно плохо документированы. Я рекомендую при работе с отладчиком почаще пользоваться
# командой help и продвигаться методом проб и ошибок.
# Существуют также и графические отладчики. Если они вас интересуют, обратитесь к главе 21 "Инструменты разработки 
# для Ruby", где обсуждаются интегрированные среды разработки (IDE).

# Отладка с помощью Pry
# Всякий программист на Ruby знаком с программой irb. Но многие считают, что недавно появившийся инструмент pry 
# гораздо лучше. Для установки Pry добавьте его в Gemfile проекта или выполните команду gem install pry.
# Как и irb, pry основан на принципе REPL (read-eval-print-loop - цикл чтения-вычисления-печати). Однако он включает
# ряд дополнительных возможностей, а также систему расширений, которая позволяет каждому желающему подключать свои
# модули. Существуют расширения, которые интегрируют pry с byebug и debugger, так что вы получаете всю функциональность
# отладчика плюс улучшенный механизм REPL, встроенный в pry.
# Рассмотрим, как можно остановить работающую программу и исследовать ее состояние в отладчике. Внесем в листинг ниже
# два изменения: в начале добавим require 'pry', а где-то ниже обращение к методу binding.pry:
require 'pry'

# ...
w2 = gets.chomp

binding.pry

# ...

# Вот несколько наиболее важных команд (это выдержка из оперативной справки):
cd            Сменить контекст (объект или область видимости).
find-method   Рекурсивно искать метод в классе, модуле или в текущем пространстве имен.
ls            Показать список переменных и методов в текущей области видимости.
whereami      Показать код вокруг текущего контекста.
wtf?          Показать обратную трассировку последнего исключения.
show-doc      Вывести документацию по методу или классу.
show-source   Показать исходный код метода или класса.
reload-code   Перезагрузить исходный файл, содержащий код указанного объекта.

# А теперь запустим. Ниже показано, как мы входим в среду pry и оглядываемся вокруг:
$ ruby myprog.rb
Введите слово: parental 
Введите еще одно слово: prenatal 

From: /Users/Hal/rubyway/ch16/myprog.rb @ line 23 :
       
       18:      w1 = gets.chomp
       19:
       20:      print "Введите слово: "
       21:      w2 = gets.chomp
       22:
    => 23:      binding.pry
       24:
       25:      verb = palindrome?(w1) ? "является" : "не является"
       25:      puts "'#{w1}' #{verb} палиндромом."
       27:
       28:      verb = palindrome?(w2) ? "является" : "не является"

[1] pry(main)> w1
=> "parental"
[2] pry(main)> w2
=> "prenatal"      
[3] pry(main)> palindrome?(w1)
=> false
[4] pry(main)> anagrams?(w1, w2)
=> true
[5] pry(main)> exit
'parental' не является палиндромом.
'prenatal' не является палиндромом.
'parental' и 'prenatal' являются анаграммами.
# Хотя сама программа pry не является отладчиком в традиционном смысле слова, в нее можно встроить отладчик, и она
# обладает весьма интересными функциями, которых у обычных отладчико нет. Дополнительно сведения об этих функциях
# можно найти в главе 21.

# Измерение производительности
# Я не люблю уделять слишком много внимания оптимизации скорости. В общем случае нужно правильно выбрать алгоритм
# и придерживаться здравого смысла. 
# Конечно, быстродействие имеет значение. Иногда даже очень большое. Однако начинать думать об этом на слишком раннем
# этапе цикла разработки - ошибка.
# Как говорится, "преждевременная оптимизация - источник всех зол". (Эту мысль впервые высказал Хоар, а потом
# подтвердил Кнут.). Или перефразируя, "сначала пусть работает правильно, а потом быстро". На уровне отдельного
# приложения эта рекомендация обычно оказывается хоршим эвристическим правилом (хотя для больших систем, она, быть
# может, и не так актуальна).
# Я бы еще добавил: "Не оптимизируйте, пока не измерите".
# Это не такое уж серьезное ограничение. Просто не приступайте к переработке ради скорости, пока не ответите на 
# два вопроса: "Действительно ли программа работает медленно? Какие именно ее части снижают производительность?"
# Второй вопрос важнее, чем кажется на первый взгляд. Прогаммисты часто уверены, что и так знают, на то программа
# тратит большую часть времени, но специальные исследования убедительно свидетельствуют о том, что в среднем эти 
# догадки имеют очень мало общего с действительностью. "Теоретическая" оптимизация для большинства из нас - плохая идея.
# Нам нужны объективные измерения. Профилировщик нужен.
# В комплект поставки Ruby входит профилировщик profile. Для его вызова достаточно включить библиотеку:
ruby -rprofile myprog.rb
# Рассмотрим программу в листинге ниже. Она открывает файл /usr/share/dict/words и ищет в нем анаграммы.
# Затем смотрит, у каких слов наибольшее количество анаграмм и распечатывает их.
words = File.readlines("/usr/share/dict/words")
words.map! { |x| x.chomp }

hash = {}
words.each do |word|
  key = word.split("").sort.join
  hash[key] ||= []
  hash[key] << word
end

sizes = hash.values.map { |v| v.size }
most = sizes.max
list = hash.find_all {|k, v| v.size == most}

puts "Ни у одного слова не более #{most - 1} анаграмм."
list.each do |key, val|
  anagrams = val.sort
  first = anagrams.shift
  puts "Слово #{first} имеет #{most - 1} анаграмм: "
  anagrams.each { a| puts "  #{a}" }
end

num = 0

hash.keys.each do |key|
  n = hash[key].size
  num += n if n > 1
end

puts
puts "Всего слов в словаре: #{words.size},"
puts "из них имеют анаграммы: #{num}."
# Наверняка вам интересно, какие получились результаты. Вот такие:
# Ни у одного слова нет более 14 анаграмм.
# Слово alerts имеет 14 анаграмм:
  alters
  artels 
  estral 
  laster
  lastre 
  rastle
  ratels
  relast 
  resalt 
  salter 
  slater 
  staler 
  stelar 
  talers

  # Всего слов в словаре: 483523,
  # из них имеют анаграммы: 79537.

  # На моем компьютере этот файл содержит более 483 000 тысяч слов, и программа работала чуть меньше 18 секунд. 
  # Как вы думаете, на что ушло это время? Попробуем выяснить. Профилировщик выдал более 100 строк, отсортированных
  # в порядке убывания времени. Мы покажем только первые 20:
  %  cumulative  self             self  total 
  time    seconds    seconds    calls    ms/call    ms/call    name 
  42.78   190.93     190.93        15   12728.67   23647.33    Array#each 
  10.78   239.04      48.11   1404333       0.03       0.04    Hash#[]
   7.04   270.48      31.44         2   15720.00   25575.00    Hash#each
   5.66   295.73      25.25    483523       0.05       0.05    String#split
   5.55   320.51      24.78   1311730       0.02       0.02    Array#size
   3.64   336.76      16.25         1   16250.00   25710.00    Array#map
   3.24   351.23      14.47    483524       0.03       0.03    Array#sort
   3.12   365.14      13.91    437243       0.03       0.03    Fixnum#==
   3.04   378.72      13.58    483526       0.03       0.03    Array#join
   2.97   391.98      13.26    437244       0.03       0.03    Hash#default
   2.59   403.53      11.55    437626       0.03       0.03    Hash#[]=
   2.43   414.38      10.85    483568       0.02       0.02    Array#<<
   2.29   424.59      10.21         1   10210.00   13420.00    Array#map!
   1.94   433.23       8.64    437242       0.02       0.02    Fixnum#<=>
   1.86   441.54       8.31    437244       0.02       0.02    Fixnum#>
   0.72   444.76       3.22    483524       0.01       0.01    String#chomp!
   0.11   445.26       0.50         4     125.00     125.00    Hash#keys
   0.11   445.73       0.47         1     470.00     470.00    Hash#values
   0.06   446.00       0.27         1     270.00     270.00    IO#readlines
   0.05   446.22       0.22     33257       0.01       0.01    Fixnum#+
   
# Видно, что больше всего времени программа тратит в методе Array#each. Это понятно, ведь цикл выполняется для 
# каждого слова, и на каждой итерации делает  довольно много. Среднее значение в данном случае сбивает с толку, 
# поскольку почти все время уходит на первый вызов each, а остальные 14 выполняются очень быстро.
# Мы также видим, что Hash#[] - дорогая операция (главнымм образом потому, что часто выполняется); на 1.4 миллиона
# вызовов было потрачено почти 11 секунд.
# Обратите внимание, что метод readlines оказался чуть ли не в самом конце списка. Эта программа тратит время не
# на ввод-вывод, а на вычисления. На чтение файла ушло всего четверть секунды.
# Но этот пример не показывает, в чем истинная ценность профилирования. В программе нет ни методов, ни классов.
# На практике вы, скорее всего увидите свои методы среди системных. И тогда будете точно  знать, какие из ваших
# методов находятся в числе первых 20 "пожирателей времени".

# Надо ясно понимать, что профилировщик Ruby (видно, по иронии судьбы) работает медленно. Он подключается к программе
# во многих местах и следит за ее выполнением на низком уровне (причем сам написан на чистом Ruby). Так что не
# удивляйтесь, если ваша программа в ходе сеанса профилирования будет работать на несколько порядков медленнее. 
# В нашем примере она работала 7 минут 40 секунд (460 секунд), то есть в 25 раз медленее обычного.
# Помимо профилировщика, есть еще один низкоуровневый инструмент - стандартная библиотека benchmark, которая тоже
# полезна для измерения производительности.
# Один из способов ее применения - вызвать метод Benchmark.measure и передать ему блок.
require 'benchmark'

file = "/usr/share/dict/words"
result = Benchmark.measure { File.readlines(file) }
puts result

# Выводится:    0.350000  0.070000  0.42000 (  0.418825)
  Этот метод выводит следующую информацию:
  - время, затраченное процессором в режиме пользователя (в секундах);
  - время, затраченное процессором в режиме ядра (в секундах);
  - полное затраченное время - сумма вышеупомянутых величин;
  - время работы программы (по часам).
  
# Для сравнения производительности отдельных участков удобен метод Benchmark.bm. Передайте ему блок, а он сам передаст
# блоку объект формирования отчета. Если вызвать этот объект, передав ему метку и блок, то он выведет метку, а за
# ней временные характеристики блока. Пример:
require 'benchmark'

n = 200_000
s1 = ""
s2 = ""
s3 = ""

Benchmark.bm do |rep|
  rep.report("str<<  ") { n.times { s1 << "x" } }
  rep.report("str.insert ") { n.times { s3.insert(-1,"x") } }
  rep.report("str +=  ") { n.times { s2 += "x" } }
end

# Здесь мы сравниваем три способа добавить символ в конец строки, дающие один и тот же результат. Чтобы получить более
# точные цифры, каждая операция выполняется 200 000 раз. Вот что получилось:
                   user       system       total         real
str <<         0.180000     0.000000    0.180000  ( 0.174697)
str.insert     0.200000    0.000000      0.200000  ( 0.200479)
str +=        15.250000   13.120000     28.370000  (28.375998)
# Обратите внимание, что последний вариант на два порядка медленее остальных. Почему? Какой урок можно извлечь отсюда?
# Вы можете предположить, что оператор + почему то работает медленно, но дело не в этом. Это единственный из трех
# способов, который не работает с одним и тем же объектом, а каждый раз создает новый.
# Стало быть, вывод такой: создание объекта - дорогая операция. Библиотека Benchmark может преподать много подобных
# уроков, но я все же рекомендую сначала занятья высокоуровневым профилированием.
# В пакете Minitest тоже есть средстваа эталонного тестирования (библиотека minitest/benchmark), а в RSpec - 
# флаг -profile, при наличии которого выводится информация о самых медленных спецификациях.

# Объекты форматированной печати
# Метод inspect (и вызывающий его мтеод p) предназначен для вывода объектов в виде, понятном человеку. В этом смысле он 
# является связующим звеном между тестированием и отладкой, поэтому рассмотрение его в этой главе оправдано.
# Проблема в том, что результат, формируемый методом p, бывает трудно читать. Из-за этого и появилась библиотека pp,
# добавляющая одноименный метод.
# Рассмотрим следующий искусственный пример объекта my_obj:
class MyClass

  attr_accessor :alpha, :beta, :gamma

  def initialize(a,b,c)
    @alpha, @beta, @gamma = a, b, c 
  end

end

x = MyClass.new(2, 3, 4)
y = MyClass.new(5, 6, 7)
z = MyClass.new(7, 8, 9)

my_obj = { x => y, z => [:p, :q] }

p my_obj
# Вызов метода p печатает следующее:
{#<MyClass:0xb73eed86c @beta=3, @alpha=2,
 @gamma=4>=>#<MyClass:0xb7eed72c @beta=6, @alpha=5, @gamma=7>,
 #<MyClass:0xb7eed704 @beta=8, @alpha=7, @beta=9>=>[:p, :q]}
 
# Все правильно и в общем-то даже читаемо. Но, не красиво. А давайте затребуем библиотеку pp и воспользуемся предоставляемым
# ей методом pp:
require 'pp'

# ...

pp my_obj
# Теперь вывод приобетает такой вид:
{#<MyClass:0xb7f7a050 @alpha=7, @beta=8, @gamma=9>=>[:p, :q],
 #<MyClass:0xb7f7alb8 @alpha=2, @beta=3, @gamma=4>=>
  #<MyClass:0xb7f7a078 @alpha=5, @beta=6, @gamma=7>}
# Мы получили хотя бы пробелы и разбиение на строки. Уже лучше. Но можно пойти еще дальше. Предположим, что в классе
# MyClass определен специальный метод pretty_print:
class MySubClass
  
  def pretty_print(printer)
    printer.text "MyClass(#alpha, #beta, #gamma)"
  end

end
# Аргумент printer передается вызывающей программой (или методом pp). Это аккумулятор текста, являющийся экземпляром 
# класса PP; мы вызываем его метод text и передаем ему текстовое представление self. Вот что получается в результате:
{MyClass(7, 8, 9)=>[:p, :q], MyClass(2, 3, 4)=>MyClass(5, 6, 7)}
# Разумеется, можно настроить поведение по своему вкусу. Можно, например, печатать переменные экземпляра на разных строчках
# с отступами. 
# На самом деле, в библиотеке pp есть много средств для подготовки ваших классов к совместной работе с методом pp.
# Методы object_group, seplist, breakable и прочие позволяют управлять расстановкой запятых, разбиением на строки и другими
# способами форматирования. Дополнительную информацию можно найти в документации по pp.

# Создание gem-пакетов
# Для построения gem-пакета необходимо создать файл с расширение .gemspec и поместить в него определенный код.
# Ниже приведен пример такого файла для gem-пакета drummer:
# drummer.gemspec
Gem::Specification.new do |spec|
  spec.name = "Drummer"
  spec.version = "1.0.2"
  spec.authors = ["H. Thoreau"]
  spec.email = ["cabin@waldenpond.net"]
  spec.description = %q{ A Ruby library for those who march to a dofferent drummer.}
  spec.summary = %q{Drum different}
  spec.homepage = "http://waldenpond.com/drummer"
  spec.license = "MIT"

  spec.files = Dir["./**/*"]
  spec.executables = Dir["./bin/*"]
  spec.test_files = Dir["./spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "activerecord", "~> 4.1.0"
end

# Файл не требует особых пояснений, но, если что-то непонятно, не стоит расстраиваться. После того как gemspec-файл
# создан, для построения пакета нужно выполниь команду gem build drummer.gemspec. А для загрузки на сайт rubygems.org -
# команду gem push drummer-1.0.2.gem.

# Для рассмотрения Rubygems во всех подробностях потребовалась бы целая книга, так то остановимся на этом. Дополнительные
# сведения о Rubygems, в том числе о команде gem и gemspec-файлах, обратитесь к руководствам на сайте https://guides.rubygems.org

# Управление зависимостями с помощью Bundler
# Итак, собирать и распространять отдельные библиотеки в виде gem-пакетов мы научились, но тут возникает новая 
# проблема. Gem-пакеты должны содержать небольшие библиотеки с четко определенным назначением. Сколько-нибудь
# полезному приложению, скорее всего, понадобится несколько пакетов. Как вести учет gem-пакетов, необходимых в крупном
# проекте? Что если мы захотим взять более свежую версию уже используемого пакета? Ответ на эти и другие вопросы 
# дает менеджер зависимостей Bundler.
# До появления Bundler в проектах Ruby не было возможности объявлять, какие пакеты необходимы. Чтобы развернуть проект
# на новой машине, нужно было прочитать в файле readme о том, какие gem-пакеты нужны, и оставалось лишь надеяться,
# что автор ничего не забыл и что с момента написания readme  в эти пакеты не было внесено несовместимых изменений.
# Bundler следит за всеми используемыми в проекте gem-пакетами и их версиями и позволяет одной командой установить
# любой нужный пакет.

# До появления Bundler трудности возникали не только с отслеживанием пакетов. При переходе на новую версию пакета 
# приложение могло перестать работать, если эта версия зависела от других версий остальных используемых пакетов.
# Bundler анализирует все пакеты, от которых зависит проект, и находит множество совместимых версий.
# Подготовить новый проект к использованию Bundler очень просто: нужо лишь создать файл Gemfile и записать в него
# список необходимых gem-пакетов. В Gemfile должен быть хотя бы один вызов метода source, но может быть и несколько.
# После них обычно идет список обращений к методу gem. В приведенном ниже Gemfile показаны примеры наиболее употребительных
# обращений:
source "http://rubygems.org" # Download gems from rubygems.org

gem 'red'                   # Зависимость от gem-пакета "red"
gem 'green', '1.2.1'        # Gem-пакет "green" - только версия 1.2.1
gem 'blue', '>= 1.0'        # Версия 1.0 или старше gem-пакета "blue"
gem 'yellow', '~> 1.1'      # "yellow" 1.1 или старше, но меньше 2.0
gem 'purple', '~> 1.1.1'    # Как минимум, 1.1.1, но меньше 1.2

# Назначение Gemfile - хранить список gem-пакетов, необходимых вашему проекту, вместе с указанием версий. Если проект
# содержит Gemfile, то для установки всех необходимых пакетов достаточно выполнить команду bundle install.
# Автоматически создается также файл Gemfile.lock. В отличие от Gemfile, в нем хранятся имена и номера версий всех
# установленных gem-пакетов, а также их зависимости, зависимости зависимостей и т.д.
# В состав исходного кода проекта включайте как Gemfile, так и Gemfile.lock. Это позволит других разработчикам установить
# сразу все зависимости командой bundle install.
# Поскольку в каждом проекте используются свои версии gem-пакетов, нередко возникает ситуация, когда в двух проектах
# указаны разные версии общеупотребительных пакетов, например rake и rspec. Bundler может воспрепятствовать
# использованию неподходящих версий пакета в текущем проекте, но для этого пакет нужно сначала загрузить.
# Чтобы в данном проекте использовались правильная версия gem-пакета, поставьте перед именем команды bundle exec.
# Так, вместо rake spec нужно выполнить bundle exec rake spec. Тогда гарантируется, что будет взята именно та 
# версия rake, которая нужна данному проекту.
# Поскольку писать каждый раз bundle exec быстро надоедает, имеет смысл определить для этой команды псевдоним
# оболочки, например b. Есть и альтернатива - Bundler может помещать специфичные для проекта исполняемые файлы 
# в каталог bin, например bin/rake. Дополнительные сведения смотрите в разделе документации по Bundler, посвященном
# binstub. Еще один прием - выполнить команду bundle exec bash и тем самым запустить новую оболочку, в которой
# окружение уже настроено правильно.
# Если ваше приложение представляет собой Ruby-файл, а не исполняемую программу, то оно должно затребовать Bundler
# до всех остальных gem-пакетов. Проще всего это сделать таким образом:
require 'bundler/setup'
# здесь можно затребовать другие библиотеки...

# Приложения для Rails также вызывают метод Bundler.require из файла boot.rb.
# Тогда все gem-пакеты, перечисленные в Gemfile, затребуются автоматически. Загрузка большого числа пакетов может
# занять много времени, и это типичная причина длительных задержек в момент запуска приложения. Авторы Bundler
# рекомендуют избегать вызова метода Bundler.require и помещать предложения require там, где они действительно нужны.
# Актуальную и полную информацию о Bundler можно найти в документации на сайте https://bundler.io.

# Семантическое версионирование
# Наверное, вы недоумеваете, зачем Gemfile позволяет указывать диапазон версий, например <2.5 или >=3.1.4.
# Такие требования к версии дают возможность обновлять gem-пакеты без редактирования Gemfile. Если в Gemfile
# приложения имеется команда gem "drummer", "~> 1.0", то для перехода с версии 1.0.2 на новую версию 1.0.3
# достаточно выполнить команду bundle update drummer.
# Правда, обновление gem-пакетов таит в себе опасность - что, если новая версия работает иначе, чем старая?
# Тогда приложение может "поломаться". Чтобы как-то снизить этот риск, многие разработчики пакетов прибегают к схеме
# "семантического версионирования". Звучит загадочно, но, по существу, это схема основана на трех принципах, по 
# одному для каждого числа в номере версии пакета.
# Первое число, "основной" номер версии, говорит о фундаментальных изменениях. Если основной номер увеличивается,
# знаит, надо быть готовым к изменению кода собственной программы, в которой этот gem-пакет используется.
# И наоборот, если в свой gem-пакет вы внесли несовместимые с предыдущей версией изменения, обязательно увеличьте
# основной номер версии.
# Второе число называется "дополнительным" номером версии и говорит о добавлении новых возможностей без изменения
# существующих. Gem-пакет продолжает предоставлять все, что было раньше, и кое-что сверх тго.
# Последнее, третье, число называется "добавочным" (tiny) номером версии. Если оно равно нулю, то его иногда
# опускают, например: версия 2.2. Увеличение добавочного номера означает, что исправлена какая-то ошибка.
# Риск при переходе на версию с новым добавочным номером минимален, потому что в ней не появилось ни нового кода,
# ни несовместимых изменений.
# Вообще говоря, семантическое версионирование считается наиболее полезной схемой нумерации версий. Даже для самого
# языка Ruby оно применяется, начиная с версии 2.1.0. Однако имейте ввиду, что не все gem-пакеты придерживаются
# этой схемы.
# Хотя семантическое версионирование показывает, насколько сильно изменился gem-пакет при переходе от одной версии
# к другой, оно все же не дает полного решения проблемы обновления пакетов. Тем не менее, скрупулезное соблюдение
# требований к номерам версий и использование команды bundle update делает обновление пакетов если не совсем
# беспроблемным, то уж точно менее болезненным делом.

# Загрузка зависимостей из Git
# Помимо управления gem-пакетами и их версиями, Bundler может использовать пакеты непосредственно из репозиториев git
# в которых хранится их исходный код. Поскольку git позволяет создавать собственную копию репозитория, с помощью
# Bundler очень просто создать ветвь репозитория пакета, исправить ошибку в нем и протестирвать ее. Затем можно 
# использовать исправленную версию из собственного репозитория, до тех пор пока владелец gem-пакета не примет ваше
# исправление и не положит новую версию на сайт rubygems.org.
# Следующий Gemfile означает, что нужен gem-пакет с именем "rake", и мы хотим взять его непосредственно из репозитория
# Джима Вейриха в Github:
gem "rake", git: "https://github.com/jimweirich/rake.git",
  branch: "master"
# Команда bundle install создаст клон репозитория git с данным URL и извлечет указанную ветвь или версию.

# Создание gem-пакетов с помощью Bundler
# Хотя основное назначение Bundler - управление установкой gem-пакетов, в нем есть несколько весьма удобных команд,
# реализующих надстройки над Rubygems, которые позволяют максимально удобно создавать и выпускать пакеты.
# Чтобы создать пакет "drummer" с помощью Bundler, нужо просто выполнить команду bundle gem drummer. 
# В результате будет создан каталог drummer, а в нем Ruby-файл с исходным кодом и файл .gemspec, в который можно
# записать название и описание. Выпуск gem-пакета также упрощен. Номер версии хранится в файле lib/drummer/version.rb
# После его обновления для отправки пакета на rubygems.org достаточно выполнить команду rake release.
# Разрабатывая собственный код, обращайте внимание на части, которые можно использовать повторно и будьте готовы
# оформить их в виде отдельного gem-пакета. Таким образом, нетрудно создать частный пакет, используемый только 
# в ваших проектах (мы поговорим об этом в следующем разделе). Со временем, если обнаружится, что частные gem-пакеты
# достаточно полезны, их можно будет разместить на сайте rubygems.org
# Огромное количество опубликованных бесплатных пакетов с открытым кодом - одно из самых весомых преимуществ сообщества Ruby.

# Частные gem-пакеты
# По мере развития и роста проекта или компании, скорее всего, накапливаются частные gem-пакеты для внутреннего
# пользования. Они содержат код, общий для нескольких приложений или служб, но, не предназначенный для опубликования.
# И хотя в общем случае лучше бы вынести повторно используемые библиотеки и раскрыть их код, в любом достаточно
# крупном проекте неизбежно образуются частные gem-пакеты.
# На первых порах управлять частными пакетами можно с помощью git, поскольку репозиторий Git легко закрыть, так что
# установить пакеты смогут только авторизованные пользователи. Но если число таких пакетов становится слишком велико,
# то пора задуматься о закрытом gem-сервере. Есть службы, например Gemnasium, которые предлагают организовать
# закрытый gem-сервер за несколько долларов в месяц, а также проекты типа Geminabox, которые позволяют установить
# собственный gem-сервер в любом удобном для вас месте.

# Программа Rdoc
# Программа RDoc, которую написал Дэйв Томас и поддерживает Эрик Ходел, входит в состав дистрибутива Ruby.
# Она получает на входе Ruby-код и создает каталог doc, содержещий HTML-файлы с документацией по классам, методам,
# константам и прочим элементам исходного кода.
# Замечательной особенностью RDoc является то, что он пытается вывести нечто полезное, даже если в исходном тексте
# вообще нет комментариев. Для этого она анализирует текст программы и собирает информацию обо всех классах, модулях,
# константах, методах и т.д. Тем самым можно получить более-менее полезный HTML-файл из исходного текста, не содержащего
# никакой внутренней документации. Если раньше не пробовали, попробуйте сейчас.
# Но это еще не все. RDoc также пытается ассоциировать найденные комментарии с конкретными частями программы. Общее
# правило таково: блочный комментарий, предшествующий определению (скажем, класса или метода), считается описанием
# этого определения.
# Если просто вызвать Rdoc для какого-нибудь исходного текста на Ruby, то будет создан каталог doc, в который помещаются
# все выходные файлы (стандартный шаблон сам по себе неплох, но есть и другие). Откройте в браузере файл index.html
# и изучите его.
# Ниже приведен простой (почти ничего не содержащий) исходный файл. Все определенные в нем методы пусты. Но RDoc
# даже в таком случае формирует симпатичную страницу документации.
require 'foo'

# Внешний классб MyClass
class MyClass
  CONST = 237

  # Внутренний класс MyClass::Alpha...

  class Alpha 

    # Класс The MyClass::Beta...

    class Beta
      # Метод класса Beta mymeth1
      def mymeth1
      end
    end

    # Метод класса Alpha mymeth2
    def mymeth2
    end
  end

  # Инициализировать объект
  def initialize(a,b,c)
  end

  # Создать объект со значениями по умолчанию

  def self.create
  end

  # И метод экземпляра

  def do_something 
  end

end

# В этом разделе мы обсудим еще две полезные функции. Имя каждого метода является ссылкой, при щелчке по которой
# открывается исходный текст метода.
# При изучении библиотеки это оказывается исключительно полезно - документация API ссылается на сам код.
# Кроме того, когда программа RDoc распознает URL, она помещает в выходной файл гиперссылку. По умолчанию, текст
# гиперссылки совпадает с самим URL, но это можно изменить. Если поместить в фигурных скобках какой-нибудь описательный
# текст, а за ним URL в квадратных скобках ({descriptive text} [myurl]), то этот текст и станет содержимым ссылки.
# Если текст состоит из одного слова, фигурные скобки можно опустить.

# Простая разметка
# На случай, если вы захотите улучшить форматирование документации, RDoc располагает собственным механизмом разметки,
# поэтому можно включать в исходный текст информацию о форматировании. Правила языка разметки выбраны так, что текст
# в редакторе выглядит "естественно", но вместе с тем может быть легко преобразован в HTML.
# Ниже приведено несколько примеров разметки, дополнительную информацию см. в книге "Programming Ruby" или в
# документации по RDoc API. На рисунке показано, во что преобразуется текст в примере.
# This block comment will not appear in the output.
# RDoc only processes a single block comment before
# each piece of code. The empty line after this
# block separates it from the block below.

# This block comment will be detected and
# included in the rdoc output.
#
# Here are some formatting tricks.
#
# Boldface, italics, and "code" (without spaces):
# This is *bold*, this is _italic, and this is +code-.
#
# With spaces:
#
# This is a bold phrase. Have you read Intruder
# in the Dust? Don't forget to require thread
# at the top.
# = First level heading
# == Second level heading
# === Third level heading
#
# Here's a horizontal rule:
# --
#
# Here's a list:
# - item one
# - item two
# - item three

class MarkupDocumentation
  # This block will not appear because the class after
  # it has been marked with a :nodoc: directive.
  class NotDocumented # :nodoc:
  end
end

# This block comment will not show up in in the output.
# Pdoc only processes blocks immediately before code,
# and this comment block as after the only code in this
# listing

=begin
This is a bold phrase. Have you read Intruder 
in the Dust? Dont forget to require thread
at the top.

= First level heading
== Second level heading
=== Third level heading

Here's a horizontal rule:
---

Here's a list:
- item one
- item two 
- item three

=end

=begin
This block comment is utagged and will not show up in
rdoc output. Also, I'm not putting blank lines between
the comments, as this will terminate the comments until
some real program source is seen. If this comment had
been before the previous one, processing would have
stopped here until program text appeared.
=end

# Внутри блока комментариев, начинающегося со знака #, можно отключить копирование текста в выходной файл, вставив
# строку #-- (а следующая такая строка вновь включает копирование). Ведь не все комментарии должны быть частью 
# пользовательской документации.
# Наконец, внутри блочных комментариев могут встречаться теги, изменяющие сгенерированный RDoc HTML-файл. Ниже
# приведены наиболее употребительные:
   :include: - включить в документацию содержимое указанного файла. Величины отступов будут скорректированы, чтобы
   не портить внешний вид.
   :title: - задать заголовок документа.
   :main: - задать начальную страницу документации.

# Создание улучшеной документации с помощью Yard
# Хотя RDoc - замечательный инструмент (к тому же включенный в дистрибутив Ruby), существует еще одно средство
# для подготовки документации с дополнительными возможностями: Yay! A Ruby Documentation, его еще называют YARD.
# У YARD по сравнению с RDoc есть два основных преимущества: динамический предварительный просмотр документации 
# по мере ввода и включение подробной информации о типах и назначении всех аргументов и возвращаемого значения
# каждого метода. На рис. 17.3 приведен пример документа, формируемого YARD при запуске для кода из листинга 17.1.
# Дополнительне сведения о YARD можно найти на сайте https://yardoc.org

# Сетевое программирование
# Когда торговец говорит вам слово networking (социальные связи), он, скорее всего желает всучить свою визитную 
# карточку. Но в устах программиста это слово обозначает электронное взаимодействие физически удаленных машин, неважно
# находятся они в разных углах комнаты, в разных районах города или в разных частях света.
# Для программистов сеть чаще всего ассоциируется с набором протоколов TCP/IP - тем языком, на котором неслышно
# беседуют миллионы машин, подключенных к сети Интернет. Несколько слов об этом наборе, перед тем как перейти к
# конкретным примерам.
# Концептуально сетевое взаимодействие принято представлять в виде различных уровней (или слоев) абстракции.
# Самый нижний уровень - канальный уровнеь, на котором происходит аппаратное взаимодействие, о нем мы говорить не
# будем. Сразу над ним расположен сетевой уровень, который отвечает за перемещение пакетов в сети, это епархия
# протокола IP (Internet Protocol). Еще выше находится транспортный уровень, на котором расположились протоколы TCP
# (Transmission Control Protocol) and UPD (User Datagram Protocol).
# Далее мы видим прикладной уровень, это мир telnet, FTP, протоколов электронной почты и т.д. и т.п.
# Можно обмениваться данными непосредственно по протоколу IP, но обычно так не поступают. Чаще нас интересуют
# протоколы TCP и UDP.
# Протокол TCP обеспечивает надежную связь между двумя компьютерами (хостами). Он упаковывает данные в пакеты и
# распаковывает их, подтверждает получение пакетов, управляет таймаутами и т.д. Поскольку протокол надежный, 
# приложению нет нужды беспокоиться о том, получил ли удаленный хост посланные ему данные.
# Протокол UDP гораздо проще, он просто отправляет пакеты (датаграммы) удаленном хосту, как будто это двоичные
# почтовые открытки. Нет никакой гарантии, что данные будут получены, поэтому протокол называют ненадежным
# (a, следовательно, приложению придется озаботиться дополнительными деталями).
# Ruby поддерживает сетевое программирование на низком уровне (главным образом, по протоколам TCP и UDP), 
# а также и на более высоких, в том числе по протоколам telnet, FTP, SMTP и т.д. На рисунке представлена схема
# иерархия классов, из которой видно, как организована поддержка сетевого программирования в Ruby/
# Отметим, что большая часть этих классов прямо или косвенно наследует классу IO. Следовательно, мы можем пользоваться
# уже знакомыми методами этого класса. Помимо этих классов, в стандартную библиотеку входят Net::IMAP, Net::POPMail,
# Net::SMTP, Net::Telnet и Net::FTP, все они наследуют непосредственно классу Object.
# Попытка документировать все функции всех показаннных классов завела бы нас далеко за рамки этой книги.
# Я лишь покажу, как можно применять их к решению конкретных задач, сопровождая примеры краткими пояснениями.
# Полный перечнь всех методов вы можете найти в справочном руководстве на сайте rdoc.info.
# Ряд важных областей применения в этой главе рассматриваться не будет, поэтому сразу упомянем о них. Класс Net::Telnet
# упоминается только в связи с NTP-серверами в разделе 18.2.2; этот класс может быть полезен не только для реализации
# собственного telnet-клиента, но и для автоматизации всех задач, поддерживающих интерфейс по протоколу telnet.
# Библиотека Net::FTP также не рассматривается. В общем случае автоматизировать обмен по протоколу FTP несложно
# и с помощью уже имеющихся клиентов, так что необходимость в этом классе возникает реже, чем в прочих.
# Класс Net::Protocol, являющийся родительским для классов HTTP, POP3 и SMTP полезен скорее для разработки новых
# сетевых протоколов, но эта тема в данной книге не обсуждается.

# Сетевые серверы
# Жизнь сервера проходит в ожидании входных сообщений и ответах на них. Не исключено, что для формирования ответа
# требуется серьезная обработка, например обращение к базе данных, но с точки зрения сетевого взаимодействия
# сервер просто принимает запросы и отправляет ответы.
# Но даже это можно организовать разными способами. Сервер может в каждый момент времени обслуживать только один 
# запрос или иметь несколько потоков. Первый подход проще реализовать, зато у второго есть преимущества, когда много
# клиентов одновременно обращаются с запросами.
# Можно представвить себе сервер, единственное назначение которого состоит в том, чтобы облегчить общение между
# клиентами. Классические примеры - чат-серверы, игровые серверы и файлообменные сети.

# Простой сервер: время дня
# Рассмотрим самый простой сервер, который только можно себе представить. Предположим, что некоторая машина 
# располагает такими точными часами, что ее можно использовать в качестве стандарта времени. Такие серверы, конечно,
# существуют, но взаимодействуют не по тому тривиальному протоколу, который мы обсудим ниже. (В разделе 18.2.2 
# приведен пример обращения к подобному серверу по протоколу telnet.)
# В нашем примере все запросы обслуживаютс в порядке поступления однопоточным сервером. Когда приходит запрос от
# клиента, мы возвращаем строку, содержащую текущее время. Ниже приведен код сервера:
require "socket"

server = UDPSocket.open         # Применяется протокол UDP..
server.bind nil, 12321

loop do
  text, sender = server.recvfrom(1)
  server.send("#{Time.now}\n", 0, sender[3], sender[1])
end
# А это код клиента:
require "socket"
require "timeout"

socket = UDPSocket.new 
socket.connect("localhost", 12321)

socket.send("", 0)
timeout(10) do 
  time = socket.gets 
  puts "The time is #{time}"
end
# Чтобы сделать запрос, клиент посылает пустой пакет. Поскольку протокол UPD ненадежен, то, не получив ответа в
# течение некоторого времени, мы завершаем работу по таймауту.

# В следующем примере такой же сервер реализован на базе протокола TCP. Он прослушивает порт 12321; запросы к этому
# порту можно посылать с помощью программы telnet (или клиента, код которого приведен ниже).
require "socket"

server = TCPServer.new(12321)

loop do 
  session = server.accept
  session.puts Time.now
  session.close
end
# Обратите внимание, как просто использовать класс TCPServer. Обращение к методу accept блокирует программу, 
# приостанавливая ее работу до получения запроса на подключение от клиента. Когда такой запрос приходит, метод
# возвращает подключенный сокет, который можно использовать в коде сервера.
# Вот TCP-версия клиента:
require "socket"

session = TCPSocket.new("localhost", 12321)
puts "The time is #{session.gets.chomp}" 
session.close

# Реализация многопоточного сервера
# Если показанный выше сервер одновременно получает несколько запросов, то следующий должен будет ждать в очереди,
# пока не закончится обслуживание предыдущего. В этом случае лучше обрабатывать каждый запрос в отдельном потоке. 
# Ниже показана реализация сервера текущего времени, с которым мы познакомились в предыщущем разделе. Он работает
# по протоколу TCP и создает новый поток для каждого запроса. 
require "socket"

server = TCPServer.new(12321)

loop do 
  Thread.new(server.accept) do |session|
    session.puts Time.new
    session.close
  end
end
# Многопоточность позволяет достичь высокого параллелизма. Вызывать метод join не нужно, поскольку сервер
# исполняет бесконечный цикл, пока его не остановят вручную.
# Код клиента, конечно, остался тем же самым. С точки зрения клиента, поведение сервера не изменилось (разве что он стал более надежным).

# Пример: сервер для игры в шахматы по сети
# Не всегда нашей конечной целью является взаимодействие с самим сервером. Иногда сервер - всего лишь средство для
# соединения клеинтов между собой. В качестве примера можно привести файлообменные сети, столь популярные 10-15 лет
# назад. Другой пример - чат серверы и разного рода игровые серверы.
# Давайте напишем скелет шахматного сервера. Мы не имеем в виду программу, которая будет играть в шахматы с клиентом.
# Нет, наша задаа - связать клиентов друг с другом, чтобы они могли затем играть в шахматы без вмешательства сервера.
# Предупреждаю, что ради простоты показания ниже программа ничего не знает о шахматах. Логика игры просто заглушена
# чтобы можно было сосредоточиться на сетевых аспектах.
# Для установления соединения между клиентом и сервером будем использовать протокол TCP. Можно было бы остановиться
# и на UDP, но этот протокол ненадежен, и нам пришлось бы самостоятельно обрабатывать повторную передачу данных и
# прием пакетов, пришедших не по порядку.
# Клиент может передать два поля: свое имя и имя желательного партнера. Для идентификации противника условимся записывать
# его имя в виде user:hostname; мы употребили двоеточие вместо напрашивающегося знака @, чтобы не вызывать ассоциаций
# с электронным адресом, каковым эта строка не является.
# Когда от клиента приходит запрос, сервер сохраняет сведения о клиенте у себя в списке. Если поступили запросы от
# обоих клиентов, сервер посылает каждому из них сообщение, теперь у каждого клиента достаточно информации для 
# установления связи с партнером.
# Есть еще вопрос о выборе цвета фигур. Оба партнера должны как-то договориться о том, кто каким цветом будет играть.
# Для простоты предположим, что цвет назначает сервер. Первый обратившийся клиент будет играть белыми (и, стало быть#
# ходить первым), второй - черными.
# Уточним. Компьютеры, которые первоначально были клиентами, начиная с этого момента общаются друг с другом напрямую, 
# следовательно, один из них становится сервером. Но на эту семантическую  тонкость я не буду обращать внимание.
# Поскольку клиенты посылают запросы и ответы попеременно и сеанс связи включает много таких обменов, то будем
# пользоваться протоколом TCP. Следовательно, клиент, который на самом деле играет роль "сервера", создает объект
# TCPServer, а клиент на другом конце - объект TCPSocket. Будем предполагать, что номер порта для однорангового
# обмена данными заранее известен, как и номер порта, по которому клиент обращается к серверу (разумеется, эти порты
# различны). Мы только что описали простой протокол прикладного уровня. Его можно было бы сделать и более хитроумным.
# Сначала рассмотрим код сервера ниже. Чтобы его было проще запускать из командной строки, создадим  поток, который
# завершит сервер при нажатии клавиши Enter. Сервер многопоточный, он может одновременно обслуживать нескольких
# клиентов. Данные о пользователях защищены мьютексом, ведь теоретически несколько потоков могут одновременно 
# попытаться добавить новую запись в список.
require "thread"
require "socket"

PORT = 12000

# Выход при нажатии клавиши Enter
waiter = Thread.new do 
  puts "Нажмите Enter для завершения сервера."
  gets
  exit
end

$mutex = Mutex.new
$list = {} 

def match?(p1, p2)
  return false unless @list[[p1]] && @list[p2]
  @list[p1][0] == p2 && @list[p2][0] == p1 
end

def handle_client(sess, msg, addr, port, ipname)
  cmd, player1, player2 == msg.split

  # Примечание: от клиента мы получаем данные в виде user:hostname,
  # но храним их в виде user:address
  player1 << ":#{addr}"                  # Добавить IP-адрес клиента

  user2, host2 = player2.split(":")
  host2 = ipname if host2 == nil 
  player2 = user2 + ":" + IPSocket.getaddress(host2)

  if cmd != "login"
    puts "Ошибка протокола: клиент послал сообщение #{msg}"
  end

  @mutex.synchronize do 
    $list[player1]  = [player2, addr, port, ipname, sess]
  end

  if match?(player1, player2)
    notify_clients(player1, player2)
  end

  def notify_clients(player1, player2)
    # Имена теперь переставлены: если мы попали сюда, значит
    # player2 зарегистрировался первым.
    p1, p2 = @mutex.synchronize do 
      [@list.delete(player1), @list.delete(player2)]
    end

    p1name = player1.split(":") [0]
    p2name = player2.split(":") [0]

    # ID игрока = name:ip:color
    # Цвет: 0=белые, 1=черные
    p1id = "#{p1name}:#{p1[3]}:1"
    p2id = "#{p2name}:#{p2[3]}:0"

    sess2 = p2[4]
    sess2.puts p1id 
    sess2.close 

    sleep 0.2        # дадим серверу запуститься
    sess1 = p1[4]
    sess1.puts p2id
    sess1.close
  end

# В этом простом примере завершаемся, не обрабатывая ошибки в потоках
Thread.abort_on_exception = true

server = TCPServer.new("0.0.0.0", PORT)
loop do 
  Thread.new(session) do |sess| 
    text = sess.gets
    print "Получено: #{text}"  # Чтобы знать, что сервер получил
    domain, port, ipname, ipaddr =  sess.peeraddr
    handle_client sess, text, ipaddr, port, ipname
    sleep1
  end
end
# Метод handle_client сохраняет информацию о клиенте. Если запись о таком клиенте уже существует, то каждому клиенту
# посылается сообщение о том, где находится другой партнер. На этом обязанности сервера кончаются.
# Клиент оформлен в виде единственной программы. При первом запуске она становится TCP-сервером, а при втором - 
# TCP-клиентом. Честно говоря, решение о том, то сервер будет играть белыми, совершенно произвольно. Вполне можно
# было бы реализовать приложение так, чтобы цвет не зависел от таких деталей.
require "socket"
require "timeout"

ChessServer     = '10.0.1.7' # Заменить этот IP-адрес
ChessServerPort = 12000
PeerPort        = 12001
White, Black    = 0, 1

def draw_board(board)
  puts <<-EOF
    +-----------------------------------+
    | Заглушка! Шахматная доска....     /
    +-----------------------------------+
    EOF
end

def analize_move(who, move, num, board)
  # Заглушка - черные всегда выигрывают на четвертом ходу
  if who == BLACK and num == 4
    move << " Мат!"
  end
  true # Еще одна заглушка - любой ход считается допустимым.
end

def get_move(who move, num, board)
  ok = false
  until ok do
    print "\nВаш ход: "
    move = STDIN.gets.chomp
    ok = analyze_move(who, move, num, board)
    puts "Недопустимый ход" unless ok 
  end
  sock.puts move
  move
end

def my_move(who, lastmove, num, board, opponent, sock)
  move = get_move(who, lastmove, num, board)
  sock.puts move 
  draw_board(board)

  case move
  when "resign"
    puts "\nВы сдались. #{opponent} выиграл."
    true
  when /Checkmate/
    puts "\nВы поставили мат #{opponent}!"
    true
  else
    false
end

def other_move(who, move, num, board, opponent, sock)
  move = sock.gets.chomp
  puts "\nПротивник: #{move}"
  draw_board(board)

  case move
  when "resign"
    puts "\n#{opponent} сдался... вы выиграли!"
    true
  when /Checkmate/
    puts "\n#{opponent} поставил вам мат."
    true
  else
    false
  end
end

if ARGV[0]
  myself = ARGV[0]
else
  print "Ваше имя? "
  myself = STDIN.gets.chomp
end

if ARGV[1]
  opponent_id = ARGV[1]
else
  print "Ваш противник? "
  opponent_id = STDIN.gets.chomp
end

opponent = opponent_id.split(":")[0]   # Удалить имя хоста

# Обратиться к серверу
socket = TCPSocket.new(ChessServer, ChessServerPort)

response = nil

socket.puts "login #{myself} #{opponent_id}"
socket.flush
response = socket.gets.chomp 
name, ipname, color = response.split ":"
color = color.to_i

if color == Black                      # Цвет фигур другого игрока
  puts "\nУстанавливается соединение..."

  server = TCPServer.new(PeerPort)
  session = server.accept

  str = nil
  begin
    timeout(30) do 
      str = session.gets.chomp
      if str != "ready"
        raise "Ошибка протокола: получен6о сообщение о готовности #{str}"
      end
    end
  rescue TimeoutError 
    raise "Не получено сообщение о готовности от противника."
  end

  puts "Ваш противник #{opponent}... у вас белые.\n"

  who = White 
  move = nil
  board = nil           # В этом примере не используется
  num = 0
  draw_board(board)     # Нарисовать начальное положение для белых

  loop do 
    num += 1 
    won = my_move(who, move, num, board, opponent, session)
    break if won
    lost = other_move(who, move, num, board, opponent, session)
    break if lost 
  end
end 
else                     # Мы играем черными
  puts "\nУстанавливается соединение..."

  socket = TCPSocket.new(ipname, PeerPort)
  socket.puts "ready"

  puts "Ваш противник #{opponent}... у вас черные.\n"

  who = Black 
  move = nil              
  board = nil            # В этом примере не используется
  num = 0
  draw_board(board)      # Нарисовать начальное положение

  loop do 
    num += 1
    lost = other_move(who, move, num, board, opponent, socket)
    break if lost 
    won = my_move(who, move, num, board, opponent, socket)
    break if won 
  end

  socket.close 
end
# Я определил этот протокол так, что черные посылают белым сообщение "ready", чтобы партнер знал о готовности 
# начать игру. Затем белые делают первый ход. Ход посылается черным, чтобы клиент мог нарисовать такую же позицию
# на доске как у другого игрока.
# Повторю, это приложене ничего не знает о шахматах. Вместо проверки допустимости хода вставлена заглушка; проверка
# выполняется локально, то есть на той стороне, где делается ход. Никакой реальной проверки нет, заглушка всегда говорит
# что ход допустим. Кроме того, мы хотим, чтобы имитация игры завершалась после нескольких ходов, поэтому написали
# программу так, что черные всегда выигрывают на четвертом ходу. Победа обозначается строкой "Checkmate!" 
# в конце хода. Эта строка печатается на экране соперника и служит признаком выхода из цикла.
# Помимо "традиционной" шахматной нотации (например, "P-K4"), существует еще "алгебраическая" нотация, которую 
# многие предпочитают. Но написанный код вообще не имеет представления о том, какой нотацией мы пользуемся.
# Поскольку это было несложно сделать, мы позволяем игроку в любой момент сдаться. Рисование доски тоже заглушено.
# Желающие могут реализовать грубый рисунок, выполненный ASCII-символами.

# Метод my_move всегда относится к локальной стороне, метод other_move - к удаленной. В листинге ниже приведен
# протокол сеанса. Действия клиентов нарисованы друг напротив друга.
% ruby chess.rb Hal                              % ruby chess.rb
Capablanca:deepthought.org                       Hal:deepdoodoo.org

Устанавливается соединение....                   Устанавливается соединение...
Ваш противник Capablanca... у вас белые.         Ваш противник Hal... у вас черные.

+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска...      |            | Заглушка! Шахматная доска...     |
+-----------------------------------+            +----------------------------------+

Ваш ход: N-QB3                                   Противник: N-QB3
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска...      |            |  Заглушка! Шахматная доска....   |
+-----------------------------------+            +----------------------------------+

Противник: P-K4                                  Ваш ход: P-K4
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска....     |            | Заглушка! Шахматная доска...     |
+-----------------------------------+            +----------------------------------+

Ваш ход: P-K4                                    Противник: P-K4
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска....     |            | Заглушка! Шахматная доска....    |
+-----------------------------------+            +----------------------------------+

Противник: B-QB4                                 Ваш ход: B-QB4
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска....     |            | Заглушка! Шахматная доска....    |
+-----------------------------------+            +----------------------------------+

Ваш ход: B-QB4                                   Противник: B-QB4
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска....     |            | Заглушка! Шахматная доска....    |
+-----------------------------------+            +----------------------------------+

Противник: Q-KR5                                 Ваш ход: Q-KR5
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска....     |            | Заглушка! Шахматная доска....    |
+-----------------------------------+            +----------------------------------+

Ваш ход: N-KB3                                   Противник: N-KB3
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска....     |            | Заглушка! Шахматная доска....    |
+-----------------------------------+            +----------------------------------+

Противник: QxP Checkmate!                        Ваш ход: QxP
+-----------------------------------+            +----------------------------------+
| Заглушка! Шахматная доска....     |            | Заглушка! Шахматная доска....    |
+-----------------------------------+            +----------------------------------+

Capablanca поставил вам мат.                     Вы поставили мат Hal!

# Получение истинно случайных чисел из веб.
# В модуле Kernel есть функция rand, которая возвращает случайное число, но вот беда - число то не является истинно
# случайным. Если вы математик, криптограф или еще какой-нибудь педант, то назовете эту функцию генератором псевдослучайных
# чисел, поскольку она пользуется алгебраическими методами для детерминированного порождения последовательности чисел.
# Случайному наблюдателю эти числа представляются случайными и даже обладают необходимыми статистическими свойствами, 
# но рано или поздно последовательность начнет повторяться. Мы можем даже намеренно (или случайно) повторить ее, 
# задав ту же самую затравку.
# Но природные процессы считаются истинно случайными. Поэтому при розыгрыше призов в лотерее счастливчики определяются
# лототроном, который хаотично выбрасывает шары. Другие источники случайности - радиоактивный распад или атмосферный шум.
# Есть источники случайных чисел и в веб. Один из них - сайт www.random.org, который и станет предметом следующего примера.

# Программа в листинге ниже моделирует подбрасывание пяти обычных (шестигранных) костей. Конечно, игровые фанаты 
# могли бы увеличить число граней до 10 или 20, но тогда стало бы сложно рисовть ASCII-картинки.
require 'net/http'

URL = "https://www.random.org/integers/"

def get_random_numbers(count=1, min=0, max=99)
  uri = URI.parse(URL)
  uri.query = URI.encode_www_form(
    col: 1, base: 10, format: "plain", rnd: "new",
    num: count, min: min, max: max
  )
  response = Net::HTPP.get_response(uri)
  case response
  when Net::HTTPOK
    response.body.lines.map(&:to_i)
  else
    []
  end
end

DICE_LINES = [
  "+-----+ +-----+ +-----+ +-----+ +-----+ +-----+ ",
  "|     | |  *  | | *   | | * * | | * * | | * * | ",
  "|  *  | |     | |  *  | |     | |  *  | | * * | ",
  "|     | |  *  | |   * | | * * | | * * | | * * | ",
  "+-----+ +-----+ +-----+ +-----+ +-----+ +-----+ "
]

DIE_WIDTH = DICE_LINES[0].length/6

def draw_dice(values)
  DICE_LINES.each do |line|
    for v in values
      print line[(v-1)* DIE_WIDTH, DIE_WIDTH]
      print " "
    end
    puts
  end
end

draw_dice(get_random_numbers(5, 1, 6))
# Здесь мы воспользовались классом Net::HTTP для прямого взаимодействия с веб-сервером. Считайте, что эта программа - 
# узкоспециализированный браузер. Мы формируем URL и пытаемся установить соединение; когда оно будет установлено, мы
# получаем ответ, возможно, содержащий некоторые данные. Если код ответа показывает, что ошибок не было, то можно
# разобрать полученные данные. Предполагается, то исключения будут обработаны вызывающей программой.
# Посмотрим на вариацию этой идеи. Что если бы мы захотели использовать эти случайные числа в каком-нибудь приложении?
# Поскольку обслуживающая программа на стороне сервера позволяет указать количество возвращаемых чисел, то было бы
# логично сохранить их в буфере. Поскольку при обращении к удаленному серверу задержки неизбежны, то нужно сразу 
# заполнить буфер во избежание лишних запросов по сети.
# В листинге ниже эта мысль реализована. Буфер заполняется отдельным потоком и совместно используется всеми экземплярами
# класса. Размер буфера и "нижняя отметка (@slack) настраиваются; какие значения задать в реальной программе, зависит
# от величины задержки при обращении к серверу и от того, как часто приложение выбирает случайное число из буфера.
require "net/http"
require "thread"

class TrueRandom

  URL = "http://www.random.org/integers/"

  def initialize(min = 0, max = 1, buffsize = 1000, slack = 300)
    @buffer = SizedQueue.new(buffsize)
    @min, @max, @slack = min, max, slack
    @thread = Thread.new { fillbuffer }
  end

  def fillbuffer
    count = @buffer.max - @buffer.size

    uri = URI.parse(URL)
    uri.query = URI.encode_www_form(
      col: 1, base: 10, format: "plain", rnd: "new",
      num: count, min: @min, max: @max
    )

    Net::HTTP.get(uri).lines.each do |line|
      @bufffer.push line.to_i
    end
  end

  def rand
    if @buffer.size < @slack && !@thread.alive?
      @thread = Thread.new { fillbuffer }
    end

    @buffer.pop
  end

end

t = TrueRandom.new(1, 6, 1000, 300)
count = Hash.new(0)

10000.times do |n|
  count[t.rand] += 1
end

p count

# При одном прогоне:
# {4=>1692, 5=>1677, 1=>1678, 1=>1635, 2=>1626, 3=>1692}

# Запрос к официальному серверу времени
# Как и обещали, приведем программу для обращения к сетевому NTP-серверу (NTP - Network Time Protocol), в которой
# класс TCPSocket используется для подключения к публичному серверу и чтения данных о текущем времени:
require "socket"

resp = TCPSocket.new("time.nist.gov", 13).read
time = ts.split(" ")[2] + " UTC "
remote = Time.parse(time)

puts "Локальное: #{Time.now.utc.strftime("%H:%M:%S")}"
puts "Удаленное: #{remote.strftime("%H:%M:%S")}"
# Мы устанавливаем соединение и читаем данные из сокета. Ответ сервера содержит дату юлианского календаря в формате
# YY-MM-DD, время в формате HH:MM:SS, количество дней до и после даты перехода на летнее время и прочие сведения.
# Мы читаем ответ целиком, выделяем из него время и печатаем его вместе с временем на локальной машине для сравнения.
# Отметим, что в этом примере мы не пользуемся протоколом NTP - более сложным и предоставляющим дополнительные 
# данные (например, задержку ответов). Вместо него мы работаем по гораздо более простомму протоколу DAYTIME.
# Полная реализация для NTP заняла бы слишком много места (впрочем, всего-то три страницы кода).
# При желании можете ознакомиться с ней, скачав gem-пакет net-ntp.

# Взаимодействие с POP-сервером
# Многие серверы электронной почты пользуются почтовым протоколом (Post Office Protocol - POP). Имеющийся в Ruby
# класс POP3 позволяет просматривать заголовки и тела всех сообщений, хранящихся для вас на сервере, и обрабатывать
# их, как вы сочтете нужным. После обработки сообщения можно удалить.
# Для создания объекта класса  Net::POP3 нужно указать доменное имя или IP-адрес сервера, номер порта по умолчанию
# равен 110. Соединение устанавливается только после вызова метода start (которому передается имя и пароль пользователя).
# Вызов метода mails созданного объекта возвращает массив объектов класса POPMail. (Имеется также итератор each
# для перебора этих объектов.)
# Объект POPMail соответствует одному почтовому сообщению. Метод header получает заголовки сообщения, а метод all -
# заголовки и тело (у метода all, как мы скоро увидим, есть и другие применения).
# Фрагмент кода стоит тысячи слов. Вот пример обращения к серверу с последующей распечаткой темы каждого сообщения:
require "net/pop"

pop = Net::POP3.new("pop.fakedomain.org")
pop.start("gandalf", "mellon")                # имя и пароль пользователя
pop.mails.each do |msn|
  puts msg.header.grep /^Subject: /
end
# Метод delete удаляет сообщение с сервера. (Некоторые серверы требуют, чтобы POP-соединение было закрыто методом
# finish, только тогда результат удаления становится необратимым.) Вот простейший пример фильтра спама:
require "net/pop"

pop = Net::POP3.new("pop.fakedomain.org")
pop.start("gandalf", "mellon")                # имя и пароль пользователя
pop.mails.each do |msg|
  if msg.all =~ /.*make money fast.*/
    msg.delete
  end
end
pop.finish

# Отметим, что при вызове метода start можно также задавать блок. По аналогии с методом File.open, в этом случае
# открывается соединение, исполняется блок, а затем соединение закрывается.
# Метод all также можно вызывать с блоком. В блоке просто перебираются все строки сообщения, как если бы мы вызывали
# итератор each для строки, возвращенной методом all.
# напечатать все строкив в обратном порядке... полезная штука!
msg.all { |line| print line.reverse}
# то же самое...
msg.all.each { |line| print line.reverse }
# Методу all можно также передать объект. В таком случае для каждой строчки (line) в полученной строке (string)
# будет вызван операток конкатенации (<<). Поскольку в различных объектах он может быть определен по-разному, то
# в результате такого обращения возможны самые разные действия:
arr = []                         # пустой массив
str = "Mail: "                   # Конкатенировать с str
out = $stdout                    # Объект IO

msg.all(arr)                     # Построить массив строчек
msg.all(str)                     # Конкатенировать с str
msg.all(out)                     # Вывести на stdout
# Наконец, покажем еще, как вернуть только тело сообщения, игнорируя все заголовки.
module Net
  class POPMail
    def body
      # Пропустить байты заголовка
      self.all[self.header.size..-1]
    end
  end
end
# Этот модуль не обладает всеми свойствами all, но его можно расширить. 

# Отправка почты по протоколу SMTP
# Название "простой протокол электронной почты" (Simple Mail Transfer Protocol SMTP) не вполне правильно. Если он
# и "простой", то только по сравнению с более сложными протоколами.
# Конечно, библиотека smtp скрывает от программиста большую часть деталей протокола. Но, на наш взгляд, эта библиотека
# интуитивно не вполне очевидна и, пожалуй, слишком сложна (надеемся, что в будущем это изменится). В этом разделе
# мы приведем несколько примеров, чтобы помочь вам освоиться.
# В классе Net::SMTP есть два метода класса: new и start. Метод new принимает два параметра: имя сервера (по умолчанию
# localhost) и номер порта (по умолчанию 25).
# Метод start принимает следующие параметры:
* server - доменное имя или IP-адрес SMTP-сервера, по умолчанию "localhost",
* port - номер порта, по умолчанию 25;
* domain - доменное имя отправителя, по умолчанию ENV["HOSTNAME"];
* account - имя пользователя, по умолчанию nil;
* password - пароль, по умолчанию nil;
* authtype - тип авторизации, по умолчанию :crab_md5.
# Обычно большую часть этих параметров можно не задавать.
# Если метод start вызывается "нормально" (без блока), то он возвращает объект класса SMTP. Если же блок задан, то
# этот объект передается прямо в блок.
# У объекта SMTP есть метод экземпляра sendmail, который обычно и занимается всеми деталями отправки сообщения.
# Он принимает три параметра:
* source - строка или массив (или любой объект, у которого есть итератор each,
  возвращающий на каждой итерации одну строку);
* sender - строка, записываемая в поле "from" сообщения;
* recipients - строка или массив строк, описывающие одного или нескольких получателей.
# Вот пример отправки сообщения с помощью методов класса:
require 'net/smtp'

msg = <<EOF
Subject: Разное
... пришла пора
Подумать о делах:
О башмаках, о сургуче,
Капусте, королях.
И почему, как суп в котле, 
Кипит вода в морях.
EOF

Net::SMTP.start("smtp-server.fake.com") do |smpt|
  smtp.sendmail msg, 'walrus@fake1.com', 'alice@fake2.com'
end

# Поскольку в начале строки находится слово Subject:, то получатель сообщения увидит тему Разное.
# Имеется также метод экземпляра start, который ведет себя практически так же, как метод класса. Поскольку почтовый
# сервер определен в методе new, то задавать его еще и в методе start не нужно. Поэтому этот параметр пропускается,
# а остальные не отличаются от параметров, передаваемых методу класса. Следовательно, сообщение можно послать и с
# помощью объекта SMTP:
require 'net/smtp'

msg = <<EOF
Subject: Ясно и логично
"С другой стороны, - добавил Тарарам, -
если все так и было, то все именно так и было.
Если же все было так, то все не могло бы быть
не так. Но поскольку все было не совсем так, все
было совершенно не так. Ясно и логично!"
EOF

smtp = Net::SMTP.new("smtp-server.fake.com")
smtp.start
smtp.sendmail msg, 'tweedledee@fake.com', 'alice@fake2.com'
# Если вы еще не запутались, добавим, что метод экземпляра может принимать также блок:
require 'net/smtp'

msg = <<EOF
Subject: Моби Дик
Зовите меня Измаил.
EOF

addressees = ['reader1@fake2.com', 'reader2@fake3.com']

smtp = Net::SMTP.new("smpt-server.fake.com")
smtp.start do |obj|
  obj.sendmail msg, 'narrator@fake1.com', addressees
end
# Как видно из примера, объект, переданный в блок (obj), не обязан называться так же, как объект, от имени которого
# называется метод (smtp). Воспользуюсь также случаем подчеркнуть, то несколько получателей можно представить в виде
# массива строк.
# Существует еще метод экземпляра со странным названием ready. Он похож на sendmail, но есть и важные различия.
# Задаются только отправитель и получатели, тело же сообщения конструируется с помощью объекта adapter класса
# Net::NetPrivate::WriteAdapter, у которого есть методы write и append. Адаптер передается в блок, где может 
# использоваться произвольным образом:
require "net/smtp"

smtp = Net::SMTP.new("smtp-server.fake1.com")
smtp.start

smtp.ready("t.s.eliot@fake1.com", "reader@fake2.com") do |obj|
  obj.write "Пошли вдвоем, пожалуй.\r\n"
  obj.write "Уж вечер небо навзничью распяло,\r\n"
  obj.write "Как пациента под ножом наркоз...\r\n"
end
# Отметим, что пары символов "возврат каретки", "перевод строки" обязательны (если вы хотите разбить сообщение на строчки).
# Читатели, знакомые с деталями протокола, обратят внимание на то, что сообщение "завершается" (добавляется точка
# и слово "QUIT") без нашего участия.
# Можно вместо метода write воспользоваться оператором конкатенации:
smtp.ready("t.s.eliot@fake1.com", "reader@fake2.com") do |obj|
  obj << "В гостиной разговаривают тети\r\n"
  obj << "О Микеланджело Буонаротти.\r\n"
end
# И еще одно небольшое усовершенствование: мы добавим метод puts, который вставит в сообщение символы перехода 
# на новую строку:
class Net::NetPrivate::WriteAdapter
  def puts(args)
    args << "r\n"
    self.write(*args)
  end
end
# Новый метод позволяет формировать сообщение и так:
smtp.ready("t.s.eliot@fake1.com", "reader@fake2.com") do |obj|
  obj.puts "Мы были призваны в глухую глубину,"
  obj.puts "В мир дев морских, в волшебную страну,"
  obj.puts "Но нас окликнули - и мы пошли ко дну."
end
# Если всего изложенного вам не хватает, поэксперементируйте самостоятельно. А если соберетесь написать новый 
# интерфейс к протоколу SMTP, не стесняйтесь.

# Взаимодействие с IMAP-сервером
# Протокол IMAP нельзя назвать вершиной совершенства, но во многих отношениях он превосходит POP3. Сообщения
# могут храниться на сервере сколь угодно долго (с индивидуальными пометками "прочитано" и "не прочитано").
# Для хранения сообщений можно организовать иерархию папок. Этих возможностей уже достаточно для того, чтобы
# считать протокол IMAP более развитым, чем POP3.
# Для взаимодействия с IMAP-сервером предназначена стандартная библиотека net/imap. Естественно, вы должны сначала
# установить соединение с сервером, а затем идентифицировать себя с помощью имени и пароля:
require 'net/imap'

host = "imap.hogwarts.edu"
user, pass = "lupin", "riddikulus"

imap = Net::IMAP.new(host)
begin
  imap.login(user, pass)
  # Или иначе:
  # imap.authenticate("LOGIN", user, pass)
rescue Net::IMAP::NoResponseError
  abort "Не удалось аутентифицировать пользователя #{user}"
end

# Продолжаем работу...

imap.logout    # разорвать соединение

# Установив соединение, можно проверить почтовый ящик методом examine; по умолчанию почтовый ящик в IMAP называется
# INBOX. Метод responses возвращает информацию из почтового ящика в виде хэша массивов (наиболее интересные данные
# находятся в последнем элементе массива). Показанный ниже код показывает общее число сообщений в почтовом ящике
# ("EXISTS") и число непрочитанных сообщений ("RECENT"):
imap.examine("INBOX")
total = imap.responses["EXISTS"].last       # всего сообщений
recent = imap.responses["RECENT"].last      # непрочитанных сообщений
imap.close                                  # закрыть почтовый ящик
# Отметим, что метод examine позволяет только читать содержимое почтового ящика. Если нужно удалить сообщения или
# произвести какие-то другие изменения, пользуйтесь методом select.
# Почтовые ящики в протоколе IMAP организованы иерархически, как имена путей в UNIX. Для манипулирования почтовыми
# ящиками предусмотрены методы create, delete и rename:
imap.create("lists")
imap.create("lists/ruby")
imap.create("lists/rails")
imap.create("lists/foobar")

# Уничтожить последний созданный ящик:
imap.delete("lists/foobar")

# Имеются также методы list (получить список всех почтовых ящиков) и lsub (получить список "активных ящиковв, на
# которые вы "подписались"). Метод status возвращает информацию о состоянии ящика.
# Метод search находит сообщения, удоввлетворяющие заданному критерию, а метод fetch возвращает запрошенное сообщение:
msgs = imap.search("TO", "lupin")
msgs.each do |mid|
  env = imap.fetch(mid, "ENVELOPE") [0].attr["ENVELOPE"]
  puts "От #{env.from[0].name}         #{env.subject}"
end
# Команда fetch в предыдущем примере выглядит так сложно, потому то возвращает массив хэшей. Сам конверт тоже представляет
# собой сложную структуру, некоторые методы доступа к нему возвращают составные объекты, другие - просто строки.
# В протоколе IMAP есть понятия UID(уникального идентификатора) и порядкового номера сообщения. Обычно методы типа
# fetch обращаются к сообщениям по номерам, но есть и варианты (например, uid_fetch) для обращения по UID.
# У нас нет места объяснять, почему нужны обе системы идентификации, но если вы собираетесь серьезно работать с
# IMAP, то должны понимать различие между ними (и никогда не путать одну с другой).
# Библиотека net/imap распологает разнообразными средствами для работы с почтовыми ящиками, сообщениями, вложениями
# и т.д. Дополнительные сведения есть в документации.

# Кодирование и декодирование вложений
# Для вложения в почтовое сообщение или в сообщение, отправляемое в конференцию, файл обычно кодируется. Как правило
# применяется кодировка base64, для работы с которой служит метод pack с аргументом m:
bin = File.read("new.gif")
str = [bin].pack("m")           # str закодирована
orig = str.unpack("m")[0]       # orig == bin
# Старые почтовые клиенты работали с кодировкой uuencode/uudecode. В этом случае вложение просто добавляется
# в конец текст сообщения и ограничивается строками begin и end, причем в строке begin указываются также разрешения
# на доступ к файлу (которые можно и проигнорировать) и имя файла. Аргумент u метода pack позволяет представить 
# строку в кодировке uuencode. Пример:
# Предположим, что mailtext содержит текст сообщения

filename = "new.gif"
bin = File.read(filename)
encoded = [bin].pack("u")

mailtext << "begin 644 #{filename}"
mailtext << encoded
mailtext << "end"
# ...

# На принимающей стороне мы должны извлечь закодированную информацию и декодировать ее методом unpack:
# ...
# Предположим, что 'attached' содержит закодированные данные
# (включая строки begin и end)

lines = attached.split("\n")
filename = \begin \d\d\d (.*) /.scan(lines[0]).first.first
encoded = lines[1..-2].join("\n")
decoded = encoded.unpack("u")         # Все готово к записи в файл
# Современные почтовые клиенты работают с почтой в формате MIME; даже текстовая часть сообщения обернута в конверт
# (хотя клиент удаляет все заголовки, прежде чем показать сообщение пользователю).
# Подробнее рассмотрение формата MIME заняло бы слишком много места, да и не относится к рассматриваемой теме. 
# Но в следующем простом примере показано, как можно закодировать и отправить сообщение, содержащее текстовую часть
# и двоичное вложение. Двоичные куски обычно представлены в кодировке base64:
require 'net/smtp'

def text_plus_attachment(subject,body,filename)
  marker = "MIME_boundary"
  middle = "--#{marker}\n"
  ending = "--#{middle}--\n"
  content = "Content-Type: Multipart/Related; " +
            "boundary=#{marker}; " +
            "typw=text/plain"
  head1 = <<-EOF
MIME-Version: 1.0
#{content}
Subject: #{subject}
  EOF
  binary = File.read(filename)
  encoded = [binary].pack("m")      # base64
  head2 = <<EOF
Content-Description: "#{filename}"
Content-Type: image/gif; name="#{filename}"
Content-Transfer-Encoding: Base64
Content-Disposition: attachment; filename="#{filename}"

EOF

  # Возвращаем...
  head1 + middle + body + middle + head2 + encoded + ending
end

domain     = "someserver.com"
smtp       = "smtp.#{domain}"
user, pass = "elgar", "enigma"

#body = <<EOF
Это мое сообщение. Особо
говорить не о чем. Я вложил
небольшой GIF-файл.

        -- Боб
EOF 
mailtext = text_plus_attachment("Привет...", body,"new.gif")
Net::SMTP.start(smtp, 25, domain, user, pass, :plain) do |mailer|
  mailer.sendmail(mailtext, 'fromthisguy@wherever.com',
                  ['destination@elsewhere.com'])
end

# Пример: шлюз между почтой и конференциями
# В онлайновых сообществах общение происходит разными способами. К наиболее распространенным относятся списки
# рассылки и конференции (новостные группы).
# Но не каждый хочет подписываться на список рассылки и ежедневно получать десятки сообщений; кто-то предпочитает 
# время от времени заходить в конференцию и просматривать новые сообщения. С другой стороны, есть люди, которым
# система Usenet кажется слишком медлительной, они хотели бы видеть сообщение, пока еще электороны не успели остыть.
# Таким образом, мы имеем ситуацию, когда в сравнительно небольшом закрытом списке рассылки рассматриваются те же
# темы, что в немодерируемой конференции, открытой всему миру. В конце концов кому-то пришла в голову мысль организовать
# зеркало - шлюз между обеими системами.
# Подобный шлюз подходит не к любой ситуации, но в случае списка рассылки Ruby он существовал с 2001 по 2011 год.
# Сообщения из конференции копировались в список, а сообщения, отправляемые в список рассылки, направлялись также
# и в конференцию.
# Эта задача была решена Дэйвом Томасом (конечно, на Ruby), и с его любезного разрешения мы приводим код в листингах
# 18.6 и 18.7.
# Но сначала небольшое вступление. Мы уже немного познакомились с тем, как отправлять и получать электронную почту
# но как быть с конференциями Usenet?
# Доступ к конференциям обеспечивает протокол NNTP(Network News Transfer Protocol - сетевой протокол передачи новостей).
# Кстати, создал его Ларри Уолл, который позже подарил нам язык Perl.
# В Ruby нет "стандартной" библиотеки для работы с NNTP, но есть несколько gem-пакетов, предлагающих функциональность
# NNTP. В примерах ниже мы пользуемся библиотекой, которую написал один японский программист (известный нам по
# псевдониму greentea.)
# В библиотеке nntp.rb определен модуль NNTP, содержащий класс NNTPIO. В этом классе имеются, в частности, методы
# экземпляра connect, get_head, get_body, и post.
# В приведенных ниже программах используется библиотека smtp, с которой мы уже познакомились.В оригинальной версии
# кода производится также протоколирование хода процесса и ошибок, но для простоты мы эти фрагменты опустили.
# Файл params.rb нужен обеим программам. В нем описаны параметры, управляющие всем процессом зеркалирования: имена
# серверов, имена пользователей и т.д. Ниже приведен пример, который вы можете изменить самостоятельно. (Все доменные имена
# содержащие слово "fake", очевидно, фиктивные)
# Различные параметры, необходимые шлюзу между почтой и конференциями
module params
  NEWS_SERVER = "usenet.fake1.org"               # имя новостного сервера
  NEWSGROUP = "comp.lang.ruby"                   # зеркалируемая конференция
  LOOP_FLAG = "X-rubymirror: yes"                # чтобы избежать цикла
  LAST_NEWS_FILE = "tmp/m2n/last_news"           # номер последнего прочитанного сообщения
  SMTP_SERVER = "localhost"                      # имя хоста для исходящей почты

  MAIL_SENDER = "myself@fake2.org"               # От чьего имени посылать почту
  # (Для списков, на которые подписываются, это должно быть имя зарегистрированного участника списка.)

  MAILING_LIST = "list@fake3.org"                # Адрес списка рассылки
end

# Модуль Params содержит лишь константы, нужные обеим программам. Большая их часть не нуждается в
# объяснениях, упомянем лишь парочку. Во-первых, константа LAST_NEWS_FILE содержит путь к файлу, в котором
# хранится идентификатор последнего прочитанного из конференции сообщения, эта "информация о состоянии"
# позволяет избежать дублирования или пропуска сообщений.
# Константа LOOP_FLAG определяет строку, которой помечаются сообщения, уже прошедшие шлюз. Тем самым мы
# препятствуем возникновению бесконечной рекурсии, а заодно гневу возмущенных обитателей сети, получивших
# тысячи копий одного и того же сообщения.
# Возникает вопрос: "А как вообще почта поступает в программу mail2news?"
# Ведь она, похоже, читает из стандартного ввода. Автор рекомендует следующую настройку: сначала в файле
# .forward программы sendmail перенаправить всю входящую почту на программу procmail. Файл .procmail
# конфигурируется так, чтобы извлекать сообщения, приходящие из списка рассылки, и по конвейеру направлять
# их программе mail2news. Уточнить детали можно в документации, сопровождающей приложение RubyMirror 
# (в архиве Ruby Application Archive). Если вы работаете в UNIX, то придется изобрести собственную схему
# конфигурирования. Ну а все остальное расскажет сам код, приведенный в листингах 18.6 и 18.7.
# mail2news: Принимает почтовое сообщение и отправляет его в конференцию

require "nntp"
include NNTP

require "params"

# Прочитать сообщение, выделив из него
# заголовок и тело. Пропускаются только
# определенные заголовки.

HEADERS = %w{From Subject Reference Message-ID
             Content-Type Content-Transfer-Encoding Date}

allowed_headers = Regexp.new(%{^(#{HEADERS.join("|")}):})

# Прочитать заголовок. Допускаются только
# некоторые заголовки. Добавить строки Newsgroups
# и X-rubymirror.

head = "Newsgroups: #{Params::NEWSGROUP}\n"
subject = "unknown"
while line = gets
  exit if line =~ /^#{Params::LOOP_FLAG}/o   # такого не должно быть
  break if line =~ /^\s*S/
  next if line =~ /^\s/
  next unless line =~ allowed_headers
  
  # вырезать префикс [ruby-talk:nnnn] из темы, прежде чем
  # отправлять в конференцию
  if line =~ /^Subject:\s*(.*)/
    subject = $1

    # Следующий код вырезает специальный номер ruby-talk
    # из начала сообщения в списке рассылки, перед тем
    # как отправлять его новостному серверу.

    line.sub!(/\[ruby-talk:(\d+)\]\s*/, '')
    subject = "[#$1] #{line}"
    head << "X-ruby-talk: #$1\n"
  end
  head << line
end

head << "#{Params::LOOP_FLAG}\n"

body = ""
while line = gets
  body << line
end

msg = head + "\n" + body
msg.gsub!(/\r?\n, "\r\n")

nntp = NNTPIO.new(Params::NEWS_SERVER)
raise "Failed to connect" unless nntp.connect
nntp.post(msg)
##
# Простой скрипт для зеркалирования трафика из
# конференции comp.lang.ruby в список рассылки ruby-talk
# 
# Вызывается периодически (скажем, каждые 20 минут).
# Запрашивает у новостного сервера все сообщения с номером,
# большим номера последнего сообщения, полученного в прошлый раз
# Если таковые есть, то читает сообщения,
# отправляет их в список рассылки и запоминает номер последнего.

require 'nntp'
require 'net/smtp'
require 'params'

include NNTP

## 
# Отправить сообщения в список рассылки. Сообщение должно
# быть отправлено участником списка, хотя в строке From:
# может стоять любой допустимый адрес.
#

def send_mail(head, body)
  smtp = Net::SMTP.new
  smtp.start(Params::SMTP_SERVER)
  smtp.ready(Params::MAIL_SENDER, Params::MAILING_LIST) do |a|
    a.write head
    a.write "#{Params::LOOP_FLAG}\r\n"
    a.write "\r\n"
    a.write body
  end
end

## 
# Запоминаем идентификатор последнего прочитанного из конференции сообщения.

begin
  last_news = File.open(Params::LAST_NEWS_FILE) { |f| f.read} .to_i
rescue 
  last_news = nil 
end

##
# Соединяемся с новостным сервером и получаем номера сообщений
# из конференции comp.lang.ruby.
#
nntp = NNTPIO.new(Params::NEWS_SERVER)
raise "Failed to connect" unless nntp.connect 
count, first, last = nntp.set_group(Params::NEWSGROUP)

##
# Если номер последнего сообщения не был запомнен раньше, сделаем это сейчас.

if not last_news
  last_news = last
end

##
# Перейти к последнему прочитанному ранее сообщению и 
# попытаться получить следующие за ним. Это может привести
# к исключению, если сообщения с указанным номером не
# существует, но мы не обращаем на это внимания.

begin
  nntp.set_stat(last_news)
rescue
end

##
# Читаем все имеющиеся сообщения и отправляем каждое в список рассылки.

new_last = last_news

begin
  loop do
    nntp.set_next 
    head = ""
    body = ""
    new_last, = nntp.get_head do |line|
      head << line
    end

    # Не посылать сообщения, которые программа mail2news
    # уже отправляла в конференцию ранее (иначе зациклимся).
    next if head =~{^X-rubymirror:}

    nntp.get_body do |line|
      body << line
    end

    send_mail(head, body)
  end
rescue
end

##
# И записать в файл новую отметку.

File.open(Params::LAST_NEWS_FILE, "w") do |f| 
  f.puts new_last 
end unless new_last == last_news

# Получение веб-страницы с известным URL
# Пусть нам нужно получить  HTML-документ из веб. Возможно, вы хотите проверить контрольную сумму и узнать, не
# изменился ли документ, чтобы послать автоматическое уведомление. А, быть может, вы пишете собственный браузер,
# тогда это первый шаг на пути длиной в тысячу километров.
require "net/http"

begin
  uri = URI(http://www.space.com/index/html)
  res = Net::HTTP.get(uri)
rescue => err 
  puts "Ошибка: #{err.class}: #{err.message}"
  exit
end

puts "Получено строк: #{res.body.lines.size} " \
     "и байтов: #{res.body.size}"
# Обработать...
# Сначала мы создаем объект класса HTTP, указывая доменное имя и номер порта сервера (обычно используется порт 80).
# Затем выполняется операция get, которая возвращает ответ по протоколу HTTP и вместе с ним строку данных. В примере
# выше мы не проверяем ответ, но если возникнет ошибка, то перехватываем ее и выходим.
# Если мы благополучно миновали предложение rescue, то можем ожидать, что содержимое страницы находится в строке data.
# Мы можем обработать ее, как сочтет нужным.
# Что может пойти не так, какие ошибки мы перехватываем? Несколько. Может не существовать или быть недоступным
# сервер с указанным именем; указанный адрес может быть перенаправлен на другую страницу (эту ситуацию мы не обрабатываем)
# может быть возвращена пресловутая ошибка 404 (указанный документ не найден). Обработку таких ошибок мы оставляем вам.

# Библиотека Open-URI
# Библиотеку Open-URI написал Танака Акира (Tanaka Akira). Её цель - унифицировать работу с сетевыми ресурсами 
# из программы, предоставив интуитивно очевидный и простой интерфейс.
# По существу она является оберткой вокруг библиотек net/http, net/https и net/ftp, и предоставляет метод open,
# которому можно передать произвольный URI.
# Пример из предыдущего раздела можно было бы переписать следующим образом:
require 'open-uri'

site = open("http://www.marsdrive.com")
data = site.read
puts "Получено строк: #{data.split.size}, байтов: #{data.size}"
# Объект, возвращаемый методом open (f в примере выше), - не просто файл. У него есть также методы из модуля
# OpenURI::Meta, поэтому мы можем получить метаданые:
uri = f.base_uri                    # объект URI с собственными методами доступа
ct = f.content_type                 # "text/html"
cs = f.charset                      # "utf=8"
ce = f.content_encoding             # []
# Библиотека позволяет задать и дополнительные заголовочные поля, передавая методу open хэш. Она также способна
# работать через прокси-серверы и обладает рядом других полезных функций. В некоторых случаях этой библиотеки
# недостаточно, например, если необходимо разбирать заголовки HTTP, буферизовать очень большой скачиваемый файл,
# отправлять куки и т.д. Дополнительные сведения можно найти в онлайновой документации на сайте: rdoc.info.

# Ruby и веб-приложения
# За последние десять лет Ruby завоевал невероятную популярность. Хотя Ruby - универсальный язык, на котором можно
# писать любые программы, своей славой он обязан, прежде всего, одной единственной библиотеке - Ruby on Rails. 
# Созданная Дэвидом Хейнемейером Хансоном и впервые выпущенная в 2004 году, Rails (как ее раньше называли) позволяет
# создавать функционально насыщенные интерактивные веб-приложения с невиданной дотоле скоростью.
# В этой главе мы узнаем, как отвечать на HTTP-запросы от браузера или другого веб-клиента (например, мобильного
# приложения или какой-то веб-службы). Мы кратко расскажем о достоинствах таких веб-каркасов как Rails и Sinatra, 
# и рассмотрим многочисленные инструменты, которые интегрируются с этими каркасами, чтобы упростить работу с хранилищами
# данных, HTML, CSS и JavaScript.  Наконец, мы остановимся на том, как разрабатывать на Ruby свой API и потреблять
# API, написанные другими людьми. И еще поговорим о том, как без особых усилий создавать сложные статические сайты.
# Ну а начнем с HTTP-серверов.

# HTTP-серверы
# Доля HTTP-сервисов среди используемых сегодня программ очень высока. Они предоставляют интерфейсы к средствам
# коммуникации, документам, финансам, системам планирования путешествий, да чуть ли не ко всем сторонам современной
# жизни. Но каким бы сложным ни было приложение, в его основе всегда лежит очень простой протокол HTTP. По существу
# HTTP сводится к нескольким строкам обычного текста, описывающим запросы и ответы, посылаемые через TCP-сокет.

# Простой HTTP-сервер
# Чтобы продемонстрировать простоту HTTP, напишем на Ruby HTTP-сервер, к которому можно обратиться из любого браузера.
# Попробуйте запустить программу показанную в листинге ниже, а потом открыть URL http://localhost:3000 в своем браузере.
require 'socket'
server = TCPServer.new 3000

loop do
  # Принять запрос на подключение
  socket = server.accept

  # Напечатать запрос, заканчивающийся пустой строкой
  puts line = socket.readline until line == "\r\n"

  # Сообщить браузеру, что он общается с HTTP-сервером
  socket.write "HTTP/1.1 200 OK\r\n"

  # Сообщить браузеру, что длина тела составляет 52 байта
  socket.write "Content-Length: 51\r\n"

  # Пустая строка, отделяющая заголовки от тела
  socket.write "r\n"

  # Вывести HTML-код, составляющий тело
  socket.write "<html><body>"
  socket.write "<h1>Hello from Ruby!</h1>"
  socket.write "</body></html>\n"

  # Закрыть соединение
  socket.close
end
# Здесь мы принимаем входящие запросы на подключение по протоколу TCP. Затем печатаем каждую строку, отправленную 
# браузером, пока на встретим пустую строку. Далее мы отправляем HTTP-ответ - простой текст в определенном формате, 
# понятном браузеру.
# Ответ состоит из кода состояния, заголовков и тела. В нашем случае посылается код состояния 200, означающий, что
# ни запрос, ни ответ не содержат ошибок. Есть много других кодов состояния, в том числе перенаправление на другой
# адрес(301 и 302), отсутствие данных по указанному адресу (404) и даже ошибка сервера (500). Полный перечень можно
# найти в сетевых справочниках, например в википедии или на сайте httpstatus.es.
# Вслед за кодом состояния мы посылаем один заголовок, сообщающий браузеру, сколько будет байтов в следующем далее теле.
# Могут быть и другие заголовки в которых, указывается, например, какого рода информация содержится в теле
# (HTML, JSON, XML или даже видео или аудио), является ли тело сжатым и т.д.
# Далее мы посылае пустую строку, означающую, что заголовки кончились и начинается тело. Вероятно, вы обратили
# внимание, что строка заканчивается не одним символом перевода строки \n, а парой \r\n (возврат каретки и перевод строки).
# Одиночный символ перевода строки применяется для завершения строк в системах UNIX и Mac OS X, а пара символов -
# в системе Windows и некоторых других, а также в запросах и ответах по протоколу HTTP.
# Если теперь запустить сервер и перейти по адресу localhost:3000 в браузере, то появится стрка "Hello from Ruby",
# напечатанная крупным полужирным шрифтом. А на экране терминала вы увидите текст, который браузер посылает серверу.
# На моей машине было напечатано:
GET / HTTP/1.1
Host: localhost:3000
Accept: text/html, application/xhtml+xml,application/xml;q=0.9,
  */*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: en-us
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4)
AppleWebKit/537.78.2 (KHTML, like Gecko)
Version/7.0.6 Safari/537.78.2
Cache-Control: max-age=0
Connection: keep-alive
# Это и есть HTTP-запрос. Как видите, он очень похож на HTTP-ответ, сформированный нами в листинге 19.1.
# Запрос начинается строкой объявления, в данном случае это запрос GET к пути /. Заголовок Host определяет доменное
# имя, связанное с данным запросом, в нашем случае localhost. Различные заголовки Accept говорят, что браузер желал ба
# получить ответ в формате HTML, XHTML или XML, что ответ может быть сжатым и должен быть на английском языке.
# Заголовок User-Agent сообщает, что запрос был отправлен из браузера Safari версии 7.0.6.

# Rack и веб-серверы
# Любой HTTP-сервер принимает запросы, подобные рассмотренному выше, и отправляет ответы так, как это сделали мы.
# В 2007 году Кристиан Нойкирхен (Christian Neukirchen) написал библиотеку Rack, которая предоставляет единый API
# для всех написанных на Ruby HTTP-серверов и веб-приложений.
# Имейте в виду, что Rack предназначена не для высокоуровневой разработки, а для создания инструментов, библиотек
# и каркасов. Кроме того, она рассчитана на опытных программистов, а пользователи каркаса или библиотеки, обычно
# не видят Rack API. Если разобраться в назначении с способах работы с Rack, то в ваших руках окажется мощнейший 
# инструмент.
# На мой взгляд Rack - просто гениальное изобретение. За несколько лет, прошедших с момента ее появления, написанные
# на ее основе программы обработали много триллионов запросов.
# Рассмотрим некоторые детали работы этой библиотеки. HTTP-запрос, как минимум, включает набор параметров, организованный
# в виде подобия хэша. Возвращаемый ответ состоит из трех частей: код состояния, набор заголовков и тело.
# Допустим, что у объекта имеется метод call, который возвращает массив такого формата. Любой класс, следующий 
# описанным правилам, можно считать Rack-приложением. Вот простейший пример такого класса:
class MyRackApp
  def call(env)
    [200, {'Content-type' => 'text/plain'}, ["Welcome to Rack!"]]
  end
end
# Отметим, что тело само является массивом, а не простой строкой. Объясняется это соглашением, по которому тело
# должно отвечать на вызов метода each. (На самом деле, простая строка тоже сгодилась бы, если бы она отвечала на
# вызов each, как было в старых версиях Ruby.)
# Ну и как запустить такое приложение? Способов несколько. В состав Ruby входит утилита rackup. По сути дела, это
# исполнитель приложений, умеющий работать с файлами с расширением .ru. Ниже приведен пример такого файла, который
# просто вызывает приложение, передавая методу run объект в качестве параметра.
# Предполагается приведенное выше определение
app = MyRackApp.new
run app

# По соглашению, Rack-приложене конфигурируется с помощью написанного на Ruby файла config.ru. Пользуясь несложным
# Rack API, мы можем сильно упростить HTTP-сервер. В приведенном ниже фрагменте тот же самый HTTP-ответ посылается
# средствами Rack. Обратите внимание насколько лаконичнее стрелка, обозначающая лямбда-выражение:
run -> (env) { [
  200, {"Content-Type" => "text/html"}, ["<html><body>",
    "<h1>Hello from Ruby!</h1>", "</body></html>"]
] }

# Любое Rack-приложение должно отвечать на обращения к методу call, который вызывается один раз для каждого запроса.
# Аргумент env, передаваемый методу call, содержит информацию о запросе: глагол HTTP, путь, заголоввки, IP-адрес
# клиента и многое другое.
# Поскольку любой Proc-объект умеет отвечать на вызов call, простейшим Rack-приложением является лямбда, как в
# примере выше. Каждое Rack-приложение должно возвращать Rack-ответ: массив из трех элементов, содержащий код
# состояния (число), заголовки ответа (в виде хэша) и тело (в виде объекта, отвечающего на вызовы each; в нашем случае
# это массив).
# Важная концепция, благодаря которой библиотека Rack и является столь полезной, - идея ПО промежуточного уровня.
# Можно считать, что это некая программа. расположенная между браузером (или клиентом) и сервером. Она обрабатывает
# запросы, посылаемые клиентами серверу, и ответы сервера клиентам.
# При этом компоненты промежуточного уровня можно более-менее произвольно "сцеплять". Каждый следующий компонент
# каким то образом преобразует поток данных. Можно рассматривать это как аналог конвейера (|) в UNIX.
# Существуют соглашения и приемы написания компонентов промежуточного уровня, но здесь мы их рассматривать не будем.
# Отметим лишь, что имеется великое множество готовых компонентов - как входящих в состав Rack, так и написанных
# сторониими разработчиками. Они реализуют, например, HTTP-кэширование, фильтрацию спама, проверку работоспособности
# отправкой периодического сигнала-пульса, аналитику Google и многое другое.
# Если вы собираетесь всерьез использовать Rack, то должны познакомиться с классом Rack::Builder; это предметно-
# ориентированный язык для сборки Rack-приложений из кусочков. Утилита rackup преобразует ru-файлы в объект Builder
# "за кулисами", но, если требуется большая гибкость и дополнительные возможности, то вы можете сделать это и
# самостоятельно.
# Для запуска Rack-приложения можно использовать любой из многочисленных совместимых с Rack HTTP-серверов, написанных
# на Ruby. Этим вы избавите себя от необходимости писать и поддерживать TCP-сервер, корректно разбирать HTTP-запросы
# и форматировать HTTP-ответы. Если никакой другой сервер не установлен, то Rack по умолчанию возьмет сервер Webrick,
# входящий в состав дистрибутива Ruby, но для производственных приложений он не годится. Самый популярный написанный
# на Ruby веб-сервер - Unicorn, он оптимизирован под однопоточныее приложения интерпретатора MRI.
# Дополнительные сведения о Unicorn можно найти в документации на сайте unicorn.bogomips.org. Лично я предпочитаю
# веб-сервер Puma, который поддерживает многопоточные приложения, а также интерпретаторы MRI, jRuby и Rubinius.
# Дополнительную информацию о нем смотрите на сайте puma.io.

# Обратите также внимание на сообщения, печатаемые на консоли сервером Puma и библиотекой Rack. Сервер выводит
# одну строку для каждого запроса, которая включает IP-адрес отправителя, дату и время, глагол HTTP, версию протокола
# HTTP, возвращенный код состояния и время, потраченное на обработку запроса. Вот что печатается на консоли после
# запуска Puma и отправки одного запроса:
Puma starting in single mode...
* Version 2.9.0 (ruby 2.1.2-p95), codename: Team High five
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://0.0.0.0:9292
Use Ctrl-C to stop
127.0.0.1 - - [02/Sep/2014 16:32:26] "GET / HTTP/1.1" 200 - 0.0001
# При работе с Rack можно получить всю ту информацию, которую мы получаем при самостоятельном чтении запросов из
# TCP-сокета, но усилий для этого приходится прилагать не в  пример меньше. Достаточно просто прочитать из хэша
# env значение того или иного ключа. Над Rack и его унифицированным серверным API надстроены различные каркасы 
# приложений, и, в частности, Rails.

# Каркасы приложений
# Вы наверняка понимаете, что веб-приложение очень быстро может стать чрезмерно сложным и громоздким, даже при 
# использовании абстракций, предоставляемых Rack. И вот здесь-то вступают в игру каркасы для построения веб-приложений
# типа Rails и Sinatra. Веб-каркас предлагает, как минимум, дополнительный уровень абстракции, который позволяет
# вызывать различные методы в зависимости от глагола HTTP, пути и других условий.
# Ruby on Rails - каркас, в который "все включено". В него входит командная утилита для создания и запуска Rails-приложений
# и многочисленные библиотеки, отвечающие за такие аспекты, как хранение данных, отрисовка HTML-шаблонов, управление
# CSS и JavaScript и многие другие.
# Каркас Sinatra гораздо меньше по объему, чуть ли не единственная его функциональность - отображение между URL и
# Ruby-кодом. Все дополнительные возможности предоставляются другими библиотеками (на самом деле, во многих приложениях
# Sinatra используются части Rails). В этом разделе мы приведем примеры использования Rails и Sinatra, а в оставшейся
# части главы рассмотрим дополнительные инструменты и библиотеки, интегрирующиеся с Rails (и допускающие использование
# Sinatra).
# Существуют и другие каркасы веб-приложений для Ruby, в том числе почтенный Ramaze, совсем новенький Lotus и т.д.
# Если вас интересуют различные способы построения веб-каркасов, определенно стоит изучить несколько вариантов.
# Если же ваши интересы ограничиваются только разработкой собственно веб-приложений, то я рекомендую пользоваться
# Rails. Это самый популярный каркас с максимальным количеством пользователей, для него существует масса примеров,
# решений и пособий, так что вам точно будет куда обратиться за помощью в случае необходимости.
# Получив запрос, каркас веб-приложений должен первым делом решить, какой код вызвать для его обработки. Это обычно
# называется маршрутизацией, соответствующие механизмы есть и в Rails, и в Sinatra, хотя устроены они по-разному. 
# Сначала рассмотрим Sinatra, а потом перейдем к Rails.
# Примеры из этой главы были протестированы для версий Sinatra 1.4.5 и Rails 4.1.5 работающих с версией Ruby 2.1.2
# Если с тех пор вышли новые версии, то ситуация может измениться. При необходимости вы можете установить указанные
# версии и выполнить примеры.

# Маршрутизация в Sinatra
# Gem-пакет Sinatra надстроен над библиотекой Rack и добавляет к ней сравнительно немного функциональности. Приложения
# Sinatra отображают указанные в запросе глаголы HTTP и пути на соответствующие блоки кода. В листинге ниже создается
# приложение Sinatra, эквивалентное пказанному ранее.
# В прочем, мы пошли немного дальше и добавили еще один путь. Не будь Sinatra, путь пришлось бы анализировать самостоятельно
# и выполнять разный код в зависимости от того, что указано в запросе. Sinatra делает это автоматически, мы должны
# лишь определить соответствие между комбинацией глагола и пути и написанным на Ruby кодом.
require 'sinatra'

get "/" do 
  <<-HTML
    <html>
      <body>
        <h1>Hello from Ruby!</h1>
      </body>
    </html>
  HTML
end

get "/world" do
  <<-HTML
    <html>
      <body>
        <h1>Hello, World!</h1>
      </body>
    </html>
  HTML
end

# Чтобы выполнить этот пример, сохраните показанный в листинге код в файле sinatra.rb. При необходимости установите
# gem-пакет Sinatra командой gem install sinatra, после чего запустите сервер командой ruby sinatra.rb.
# Теперь, перейдя в браузере по адресу http://localhost:4567, вы увидите первоначальное сообщение, а перейдя по адресу
# http://localhost:4567/world - сообщение "Hello, World!".
# На консоль приложение Sinatra выводит почти то же самое, что приложение Rack. Единственное мелкое отличие - 
# вторая строка журнала, относящаяся к запросу к URL "/world".
Puma 2.9.0 starting...
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://localhost:4567
== Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Puma
127.0.0.1 - - [02/Sep/2014 17:36:33] "GET / HTTP/1.1" 200 51 0.0047
127.0.0.1 - - [02/Sep/2014 17:36:38] "GET / world HTTP/1.1" 200 48 0.0004

# Маршрутизация в Rails
# Теперь рассмотрим, как тот же самый пример реализуется в Rails. Сам gem-пакет Rails содержит немного кода, т.к.
# Rails объединяет в единое целое другие библиотеки, содержащие четко очерченную функциональность. Класс ActionController,
# входящий в состав gem-пакета action_pack, подходит к задаче маршрутизации иначе, чем в Sinatra. В Rails вызывается
# код, находящийся внутри контроллера, а в файле routes.rb указывается, какой метод какого контроллера соответствует
# данному пути.
# Реализуем наш пример в виде небольшого приложения Rails. Для начала установите каркас Rails и все его компоненты
# командой gem install rails, если не сделали это раньше. Затем выполните команду rails new hello. В результате
# будет создан каталог hello, содержащий заготовку приложения Rails. На данный момент большая часть созданных 
# файлов нас не интересует, а если вы хотите углубиться в тему, почитайте руководство "Getting Started with Rails"
# на сайте guides.rubyonrails.org.
# Перейдите в каталог вновь созданного приложения командой cd hello и выполните команду bin/rails generate controller hello.
# Будет создано несколько файлов, из которых нам интересен только app/controllers/hello_controller.rb.
# Откройте в редакторе и введите такой код:
class HelloController < ApplicationController
  def index
    render inline: "<h1>Hello from Ruby!</h1>"
  end

  def world
    render inline: "<h1>Hello, World!</h1>"
  end
end
# Мы добавили в класс HelloController два метода - index и world. Имена могут быть любыми, с путем они связываются
# при настройке маршрутизации. Чтобы добавить маршруты, нужно отредактировать файл config/routes.rb. В этом заранее
# сгенерированном файле содержатся подробные пояснения по поводу маршрутов разного вида, но, для нашего примера
# достаточно таких четырех строк:
Rails.application.routes.draw do
  get "/" => "hello#index"
  get "/world" => "hello#world"
end
# Объявление маршрута в Rails состоит из вызова метода, имя которого совпадает с маршрутизируемым глаголом HTTP.
# Этому методу передается хэш, в котором ключом является путь, а значением - имя контроллера и метода в нем в формате
# name#index. Как нетрудно догадаться, первый из показанных выше маршрутов означает, что запрос к пути "/" должен
# обслуживаться методом index контроллера hello, а запрос к пути "/world" методом world того же контроллера.
# Чтобы выполнить этот пример, введите команду bin/rails server. Вы уже, наверное, поняли, что команда rails - 
# портал ко всем типичным задачам, встречающимся при создании веб-приложений для Rails. Когда сервер запустится, 
# перейдите в браузере по адресу http://localhost:3000 и посмотрите, что возвращает наш пример. Для просмотра
# второго варианта перейдите по адресу http://localhost:3000/world.
# Вывод в окне терминала теперь выглядит по-другому: для каждого запроса читается несколько строк. В них представлены
# те же элементы, что и в предыдущих примерах: глагол HTTP, указанный в запросе путь, IP-адрес отправителя, возвращенный
# код состояния и время обработки запроса:
=> Booting Webrick
=> Rails 4.1.5 application starting in development on http://0.0.0.0.3000
=> Run `rails server -h` for more startup options
=> Ctrl-C to shutdown server
[2014-09-02 17:29:32] INFO WEBrick 1.3.1
[2014-09-02 17:29:32] INFO ruby 2.1.2 (2014-05-08) [x86_64-darwin13.0]
[2014-09-02 17:29:32] INFO WEBrick::HTTPServer#start: pid=20372 port=3000

Started GET "/" for 127.0.0.1 at 2014-09-02 17:29:32 -0700
Processing by HelloController#index as HTML
  Rendered inline template (0.6ms)
Completed 200 OK in 10ms (Views: 3.2ms | ActiveRecord: 0.0ms)

Started GET "/world" for 127.0.0.1 at 2014-09-02 17:29:39 -0700
Processing by HelloController#world as HTML
  Rendered inline template (0.2ms)
Completed 200 OK in 1ms (Views: 0.4ms | ActiveRecord: 0.0ms)
# Но вторая и третья строки содержат новую информацию: имя контроллера и метода, вызванного в ответ на запрос, в
# данном случае HelloController#index и #world. Мы видим также, что для генерации ответа отрисовывался встроенный
# шаблон (inline template). Шаблоны мы будет обсуждать в разделе 19.4
# Помимо пути, в HTTP-запросе могут быть указаны параметры - наборы ключей и значений, формируемые браузером обычно
# на основе данных, введенных пользователем. И в Sinatra и в Rails параметры доступны через хэш params.
# В этот хэш элементы попадают либо из URL, либо из тела запроса, если запрос отправлен с помощью глагола POST.
# С помощью параметров мы можем сделать наши примеры динамичными, т.е. результат будет зависеть от отправленных клиентом данных.

# Параметры в Sinatra
# Добавим в приложение Sinatra еще пример, в котором строка запроса будет содержать один параметр, следующий после
# знака ?. Откройте сохраненный ранее файл sinatra.rb (листинг 19.3) и допишите в конец такой код:
get "/hello/:name" do 
  body = "<html><body><h1>Hello"
  body << " from " << CGI.h(params[:from]) if params[:from]
  body << ", " << CGI.h(params[:name])
  body << "!<h1><html></body>"
end
# Здесь наличие параметра в URL обозначается двоеточием, как символ в Ruby.
# Теперь Sinatra знает, что при разборе URL нужно распознавать пути вида /hello/Julia или /hello/Tim. 
# Та часть пути, которая соответствует параметру :name, помещается в хэш params с ключом :name. Другой используемый
# параметр, from, не является частью этого пути. Это означает, что он должне встречаться в строке запроса, например:
# /hello/Julia?from=Ruby.
# Любой параметр, который включается в возвращаемый HTML-код, мы экранируем с помощью метода CGI.h. Метод h - синоним
# escape_html. Он принимает на входе строку и возвращает строку, в которой все специальные символы HTML экранированы.
# Это абсолютно необходимо с точки зрения безопасности, поэтому так нужно поступать всякий раз, как приложение включает в
# HTML-страницу текст, полученный от пользователя.
# Модифицировав файл, запустите сервер командой ruby sinatra.rb и проверьте, что получилось. Поэксперементируйте с 
# различными URL, задавайте разные значения name и from - и следите за результатом. Обратите внимание, что если
# параметр from отсутствует, то в ответе не сообщается, от кого пришел привет, а если отсутствует параметр name
# (например, путь содержит только /hello/), то возвращается сообщение об ошибке.

# Параметры в Rails
# Обработка параметров в Rails и Sinatra очень похожа. Добавьте в файл app/controllers/hello_controller.rb метод hello
# (определение метода должно располагаться внутри блока class/end).
def name
  response = "<h1>Hello"
  response << " from " << h(params[:from]) if params[:from]
  response << ", " << h(params[:name])
  response << "!</h1>"
  render inline: response
end
# Затем откройте файл config/routes.rb и добавьте следующую строку перед последним end:
get "/hello/:name" => "hello#name"
# Как и раньше, имя метода (name) не имеет значения, но, с моей точки зрения, проще запомнить, что путь /hello/:name
# ведет на контроллер Hello и метод name. Снова запустите сервер командой bin/rails server и перейдите в браузер по
# адресу http://localhost:3000/hello/Zelda?from=Ruby. Вы увидите тот же ответ, что и раньше.

# Обратите внимание, что на консоли появилась новая строчка, содержащая параметры запроса. Sinatra не протоколирует
# эту информацию для каждого запроса, а показывает только путь. Rails протоколирует и путь, и параметры:
Parameters: {"name"=>"Zelda"}
Parameters:: {"from"=>"Ruby", "name"=>"Zelda"}
# Ни Sinatra, ни Rails сказанным отнюдь не исчерпываются, но погружаться слишком глубоко мы не можем из-за нехватки
# места. Дополнительные сведения о Sinatra можно найти на сайте sinatrarb.com или в книге Alan Harris, Konstantin Haase
# "Sinatra: Up and Running".
# Мы еще немного разовьем пример для Rails в следующих разделах, а полную документацию вы можете найти в Интернете
# по адресу rubyonrails.org/documentation или в книге Obie Fernandes, Kevin Faustino "The Rails 4 Way".
# Познакомившись с основами маршрутизации и обработки параметров в Sinatra и Rails, перейдем к сохранению данных 
# с помощью библиотеки ActiveRecord для Rails.

# Хранение данных
# В веб-приложениях сохранять данные труднее, чем в других программах Ruby, потому что HTTP, по определению, 
# является протоколом без сохранения состояния. Это означает, что от HTTP-сервера не требуется сохранять какую-либо
# информацию между запросами. Причины технические и обусловлены, в основном, простым соображением: одно и то же
# приложение может работать на нескольких машинах, но, получаемый клиентом ответ не должен зависеть от того, какой
# машиной обслужен запрос.
# Это позволяет одновременно обрабатывать гораздо больше запросов (поскольку следующий запрос может быть направлен
#  любому сервверу, а, значит, работа распараллеливается), но также означает, что никакой сервер не вправе сохранять
# какую-либо информацию (например, учетные данные пользователя) в переменных или в локальных файлах. Переменные 
# доступны только внутри одного процесса Ruby, а файл - только на одной машине, так что ни то,  ни другое не годится.
# Решение проблемы - использовать базу данных или хранилище данных. В разделе 10.3 мы рассматривали работу в 
# PostgreSQL, MySQL и Redis. Чем повторять уже сказанное, мы лучше воспользуемся библиотекой ActiveRecord, 
# которая позволяет создавать, читать, обновлять и удалять данные из базы с помощью объектов, не прибегая напрямую
# к SQL-запросам.

# Базы данных
# Библиотека ActiveRecord умеет подключаться к различным базам данных SQL, включая PostgreSQL, MySQL, Sqlite3 и даже
# Oracle и  Microsoft SQL. Каждая таблица базы данных представлена классом, названным по имени таблицы, который 
# наследует классу ActiveRecord::Base. Каждая строка таблицы представлена объектом этого класса, имеющим методы
# чтения и записи для каждого столбца.
# В этом разделе мы наделим наше приложение Rails способностью запоминать имена всех, кто его приветствовал, вместе
# с информацией о том, откуда был отправлен привет, если в запросе присутствует параметр from.
# В следующем разделе "Генерация HTML" мы добавим форму с текстовыми полями, содержащими сведения о том, кому и
# откуда посылается привет.
# Прежде всего, необходимо сгенерировать  модель с именем Greeting. Классы модели наследуют ActiveRecord::Base
# и работают с одноименной таблицей базы данных. Для создания модели (и файла, который добавит одноименную
# таблицу в базу данных, если его выполнить) введите команду bin/rails generate resourse greeting to:string from:string
# Будет сгенерировано несколько файлов, но нас в данный момент интересуют только два.
# Первый файл находится в каталоге db/migrations, его имя начинается временной меткой и заканчивается строкой
# create_greetings.rb. Вот что должно быть в этом файле:
class CreateGreetings < ActiveRecord::migrations
  def change
    create_table :greetings do |t|
      t.string :to
      t.string :from
      t.timestamps
    end
  end
end
# Теперь выполните команду bin/rake db:migrate. Она создаст базу данных SQL для приложения, а также файл миграции
# с кодом для создания таблицы greetings, содержащей столбцы to и from. В обоих столбцах будут храниться строки.
# После успешного завершения этой команды можно изменить метод name в файле app/controllers/hello_controller.rb
# Сделайте его таким:
def name 
  greeting = Greeting.create!(to: params[:name],
                              from: params[:from])
  render inline: "<h1>" <<CGI.h(greeting.to_s) << "!</h1>"
end
# Здесь класс Greeting используется для создания новой строки в таблице базы данных, причем в столбцы to и from
# записываются значения соответственных параметров из хэша params. Затем для создания ответа вызывается метод
# экземпляра to_s.
# Обычно не рекомендуется создавать (а тем более удалять!) записи в базе даных в ответ на запрос GET. Поисковые
# роботы, обшаривающие Интернет, периодически - сотни раз в сутки - отправляют запросы GET на все URL, о которых
# знают.
# В любом реальном приложении изменять данные следует только в ответ на запросы типа POST, PUT, PATCH и DELETE. 
# В этом примере мы создаем запись в базе в обработчике GET-запроса только простоты ради.

# Сохраните изменения, выполните команду bin/rails server и зайдите на один из ранее посещавшихся URL
# - увидите странный ответ вида #<Greeting:0x007fead16c1df8>!. Это совсем не то, что мы хотели увидеть,
# поэтому надо написать собственный метод to_s в классе Greeting, который вернет  настоящее приветствие.
# Для этого откройте файл app/models/greeting.rb и введите такой код:
class Greeting < ActiveRecord::Base
  def to_s
    s = "Hello"
    s << " from #{from} if from
    s << ", #{to}"
  end
end
# В этом методе повторно реализована уже знакомая нам логика, только теперь она является частью модели,
# а не контроллера. Поскольку за HTML-экранирование строки отвечает контроллер, нам здесь ничего экранировать
# не надо. Изменив файл greeting.rb, снова выполните команду bin/rails server - появится давно знакомое
# нам приветствие.
# Научившись сохранять все когда-либо показанные приветствия, создадим новый контроллер, который будет отображать
# все ранее отправленные приветствия.
# Отметим, что эти данные не пропадут, даже если остановить и снова запустить сервер Rails, потому что они 
# сохранены в базе данных Sqlite3.
# Чтобы создать контроллер для отображения старых приветствий, выполните команду bin/rails generate controller 
# greeting index Она добавит строку get 'greetings/index' в файл маршрутов и создаст файл app/controllers/greetings_
# controller.rb. Маршрут get 'greetings/index' - краткая запись маршрута get 'greetings' => 'greetings#index'
# Затем откройте файл контроллера и введите код формированияя ответа, содержащего список всех приветствий:
class GreetingsController < ApplicationController
  def index
    greetings = Greeting.all
    body = "<h1>Greetings</h1>\n<ol>\n"
    greetings.each do |greeting|
      body << "<li>" << CGI.h(greeting.to_s) << "</li>\n"
    end
    body << "</ol>"
    render inline: body
  end
end
# В этом действии метод all загружает все строки из таблицы greetings, преобразует каждую строку в объект класса
# Greeting и возвращает массив таких объектов. С помощью метода each мы обходим массив и включаем каждое приветствие
# в ответ. Сохранив этот файл, запустите сервер командойй bin/rails server и перейдите в браузере по адресу
# http://localhost:3000/greetings.
# В зависимости от того, сколько экспериментов вы провели после создания модели Greeting, список может оказаться 
# длинным или коротким. В любом случае не поленитесь отправить новое приветствие, а затем снова выведите список и
# убедитесь, что приветствие добавлено.
# На этом заканчивается наше короткое знакомство с библиотекой ActiveRecord.
# Эта тема настолько сложна и обширна, что сколько-нибудь подробно осветить ее у нас не хватит места, ей можно посвятить
# целые книги (и они уже написаны). Дополнительные сведения об ActiveRecord ищите в руководствах на сайте 
# guides.rubyonrails.org и в книге "The Rails 4 Way".

# Хранилища данных
# ActiveRecord - лишь одно из средств объектно-реляционного отображения (ORM) написанных на Ruby. Любой ORM
# представляет собой библиотеку, которая превращает хранимые данные в объекты Ruby, позволяет изменять эти объекты
# а затем отображает их обратно на хранимые данные. Существуют ORM для многих хранилищ данных, не основанных на SQL,
# в том числе: Mongoid для MongoDB, Couchrest для CouchDB, redis-objects для Redis.
# В большинстве случаев для веб-приложений лучше использовать популярные базы SQL с открытым исходным кодом, например
# PostgreSQL и MySQL.
# Поэтому ради экономии места мы не станем приводить примеры работы с NoSQL-хранилищами. Однако горячо рекомендуем
# заняться самостоятельно исследованиями возможностей, предоставляемых другими хранилищами.

# Генерация HTML
# Возможно, вы пришли к выводу, особенно глядя на примеры выше, что создание HTML-ответов путем конкатенации строк
# выглядит не слишком элегантно. (Если вы не знаете, как работать с HTML, то, наверное, стоит отложить чтение этого
# раздела и сначала познакомиться с основами HTML. Соответствующее справочное руководство на сайте Mozilla Developer
# Network, находящееся по адресу developer.mozilla.org/docs/Web/HTML, - вполне подходящая отправная точка.)
# Чем длиннее HTML-код ответа, тем труднее формировать его, пользуясь только строками. Поэтому в большинстве веб-каркасов
# (в том числе, в Rails) для этой цели применяются шаблоны.
# Шаблон - это файл, написанный на специальном языке, который по запросу преобразуется в HTML-код. Часто шаблоны
# содержат Ruby-код, который вставляет в HTML-разметку значения переменных. Шаблоны могут быть вложенными - тогда
# результат отрисовки одного шаблона становится частью другого.
# Обычно при использовании шаблонов создается один или несколько макетов (layout), содержащих HTML-код верхнего
# и нижнего колонтитула сайта. Макет будет повторяться на каждой странице, а в него вставляется шаблон, отрисованный
# конкретным контроллером. Наконец, небольшие фрагменты (например, повторяющиеся в цикле) можно выделить в 
# подшаблоны (partial). В каждом шаблоне используется только один язык шаблонов, но разные макеты, шаблоны и подшаблоны
# могут быть написаны на разных языках.
# Самым распространенным языком шаблонов является ERB. Он используется в Rails по умолчанию и является частью 
# стандартной библиотеки Ruby. Выглядит он очень похоже на HTML (или точнее сказать, на PHP) и предназначен для того, 
# чтобы максимально упростить вставку строк Ruby в HTML-разметку.

# ERB
# Работать с ERB не просто, а очень просто. Вот пример оформления решения математической задачи:
require 'erb'
puts ERB.new("два плюс два равно <%= 2 + 2 %>").result
# Выводится: два плюс два равно 4
# Код на языке ERB состоит из текста и erb-тегов вида <%=code%> или <% code %>.
# Если присутствует знак равенства, то значение выражения включается в текст Если знака равенства нет, то выражение
# вычисляется, но, в текст ничего не вставляется. Теги без знака равенства используются, главным образом, вместе с
# предложениями if, each и соответствующими end.
# Использовать ERB в Rails тоже очень просто. Он даже подразумевается по умолчанию. Если действие контроллера ничего
# не отрисовывает самостоятельно, то Rails ищет шаблон с таким же именем, как у действия, в каталоге с таким же
# именем как у контроллера, и возвращает результат отрисовки этого шаблона.
# Для демонстрации перепишем наш первый пример с использованием шаблона, а не контроллера. Прежде всего, нужно удалить
# все содержимое метода index в классе HelloController, оставив только пустое определение:
def index 
end
# Затем напишем шаблон, которым  должен воспользоваться Rails. Для этого создайте файл app/views/hello/index.html.erb 
# и поместите в него ставшее уже привычным сообщение:
<h1>Hello from Ruby!</h1>
# Сохранив файл, можете запустить приложение командой bin/rails server и перейти по адресу http://localhost:3000 -
# вы увидите все то же сообщение. На консоли будте написано, что Rails  отрисовал шаблон hello/index:
Rendered hello/index.html.erb within layouts/application (0.7ms)
# Теперь преобразуе в шаблон список приветствий, созданный в предущем разделе. Перепишите метод index в файле
# app/controllers/greetings_controller.rb следующим образом:
def index
  @greetings = Greeting.all
end
# В Rails переменные экземпляра, устанавливаемые в методах контроллера, доступны и в шаблоне при его отрисовке.
# Мы воспользуемся этим фактом и изменим сгенерированный ранее шаблон app/views/greetings/index.html.erb.
# Введите в него такой ERB-код:
<h1>Greetings</h1>
<ol>
<% @greetings.each do |greeting| %>
  <li><%= h(greeting.to_s) %></li>
<% end %>
</ol>

# Этот шаблон почти совпадает с кодом, написанным ранее для метода index. Основное отличие состоит в том, что 
# HTML-код пишется непосредственно, без участия строковых переменных. ERB берет на себя заботу о замене ERB-тегов
# результатами исполнения находящегося внутри них кода на Ruby.
# Для использования в шаблонах предназначены некоторые вспомогательные методы, например метод h, который делает
# тоже самое, что рассмотренный выше метод CGI.h. Отметим, что даже внутри шаблона текст приветствия нужно подвергать
# HTML-экранированию, потому что он поступил от пользователя.
# Изменив контроллер и шаблон, перезапустиите сервер Rails и перейдите в браузере по адресу http://localhost:3000/greetings
# Вы увидите тот же самый список приветствий, что и раньше, но метод контроллера теперь свелся к одной строчке.
# Теперь в нашем примере присутствуют все три части парадигмы MVC (модель-представление-контроллер), поддерживаемой
# Rails. Сохранение данных реализуется путем взаимодействия с классом модели, логика обработки запроса - контроллером, 
# который передает данные представлению, отвечающему за их отрисовку в виде HTML. Отрисованная HTML-разметка возвращается
# в составе тела HTPP-ответа, после чего обработка запроса завершается.
# Инструментарий, применяемый для работы с шаблонами в Rails, гораздо сложнее, чем мы в состоянии описать на странцах
# этой книги. Нам пора переходить к Haml, еще одной популярной шаблонной системе, а вы обязательно изучите разнообразные
# возможности отрисовки с помощью макетов, шаблонов и подшаблонов, предоставляемых Rails. 
# Дополнительные сведения см. в руководствах по шаблонам на сайте guides.rubyonrails.org и, конечно, в книге
# "The Rails 4 Way".

# 19.4.2. Haml
# Библиотека Haml - еще один язык шаблонов, сильно отличающийся от ERB. Вместо включения тегов в HTML-разметку
# в Haml HTML-теги объявляются преимущественно с помощью пунктуации. Благодаря синтаксически значимым отступам 
# удается отказаться от закрывающих тегов, угловые скобки тоже не нужны.
# Чтобы можно было воспользоваться языком Haml в нашем примере Rails-приложения, добавьте в Gemfile строку gem "haml"
# Затем выполните команду bundle install, которая добавит Haml в состав gem-пакетов, загружаемых при запуске приложения
# Rails. Дополнительные сведения о Bundler см. на сайте bundler.io.
# Для иллюстрации различий между Haml и ERB перепишем шаблон списка приветствий на Haml.
# Прежде всего нужно переименовать файл шаблона index.html.erb в каталоге app/views/greetings в index.html.haml.
# Первое расшиирение показывает, файл какого типа будет сгенерирован, второе - какая шаблонная система должна
# использоваться для генерации. Откройте файл app/view/greetings.index.html.haml и замените его содержимое кодом
# на Haml:
%h1 Greetings
%ol
  - @greetings.each do |greeting|
      %li= h(greeting.to_s)
# Как видите, ни закрывающие HTML-теги, ни строки end не нужны. Знак % в начале строки означает, что это HTML-тег,
# а все следующеее за ним - содержимое этого тега. Знак = означает, что строка содержит Ruby-код и внутрь тега
# должны быть включены результаты исполнения этого кода, а не дословное содержимое строки. Два знака равенства ==
# после тега, означают, что эта строка содержит строку Ruby, допускающую обычную интерполяцию посредством конструкции
# #{}.
# Многие пишущие на Ruby разработчики находят Haml эстетически более совершенным и считают, что писать на нем 
# гораздо быстрее, чем на ERB, благодаря меньшему количеству повторений. Но если для написания большого числа тегов
# Haml, безусловно, удобен, то этого никак не скажешь о страницах, содержащих преимущественно текст. В таких случаях
# использовать ERB обычно проще. Haml предоставляет развитый API с многочисленными возможностями и является
# привлекательной альтернативой ERB. Дополнительные сведения можно найти на сайте haml.info.

# Другие шаблонные системы
# ERB и Haml, безусловно, самые популярные шаблонные системы в Ruby, но отнюдь не единственные. В других системах
# приняты другие подходы к генерации HTML. Slim стремится по максимуму сократить объем ввода. Написанный на Slim
# шаблон насчитывает даже меньше символов, чем написанный на Haml.
# Движок Liquid, разработанный для генератора Интернет-магазинов Shopify, допускает только ограниченный набор
# синтаксических конструкций, например предложения if и циклы each. Это делает безопаснее шаблоны, разрабатываемые
# пользователями, потому что чем меньше кода, тем меньше шансов стать жертвой какого-нибудь эксплойта.
# Библиотека Mustache идет еще дальше и вообще запрещает использовать логику в шаблонах. Код должен быть выполнен
# до отрисовки - в объекте, который готовит данные для шаблона.
# Если ни ERB, ни Haml вам не по душе, оглядитесь вокруг! Есть все шансы, что найдется шаблонная система, отвечающая
# вашим потребностям и вкусам. Ну а если нет, то хочу заметить, что написание движка шаблонов - освященная временем
# традиция у рубистов, так что вперед и с песней - ваяйте свой собственный.

# Конвейер активов
# Если вы проводите много времени, бродя по Интернету, то, наверное, заметили две вещи, которые встречаются практически
# на каждом современном сайте, но в нашем приложении  пока отсутствуют: каскадные таблицы стиилей (CSS) для визуальной
# стилизации и JavaScript для программирования взаимодействия с пользователем.
# Rails предоставляет унифицированную систему управления  CSS и JavaScript.
# Во время разработки очень полезно иметь доступ к каждому CSS и JavaScript-файлу - для экспериментов, отладки и т.п.
# Но на "боевом" сайте гораздо эффективнее объеденить все таблицы стилей в один CSS-файл, а весь клиентский код -
# в один JavaScript-файл. Это уменьшает число HTTP-запросов и ускоряет загрузку страниц.
# Механизм автоматизации этого процесса включен в Rails под названием конвейера активов (asset pipeline). Любой файл
# в каталоге app/assets обрабатывается конвейером активов; на этапе обработки файлы сохраняют автономность, а на
# этапе эксплуатации объединяются. Из объединенного файла удаляются комментарии, пробелы и вообще все что можно удалить.
# Задача - сократить размер до минимума. Подобно отрисовке шаблонов, активы, написанные на одном языке, можно
# транслировать на другой. В первом нашем примере исходным будет язык SCSS, а конечным - CSS.

# CSS и Sass
# Sass, который авторы иногда называют "Syntactically Awesome Style Sheets" (синтаксически прелестные таблицы стиилей), -
# это процессор языка SCSS, являющегося надмножеством CSS. (Если вы незнакомы с CSS, то этот раздел вряд ли принесет
# вам много пользы. На сайте Mozilla Developer Network имеются справочные и учебные материалы по CSS по адресу 
# http://developer.mozilla.org/docs/Web/CSS.)
# Поскольку SCSS - надмножество CSS, то любой CSS-код одновременно является корректным кодом на SCSS, но SCSS 
# предлагает и многое сверх того. Важнейшие дополнения - переменные, вложенность, подтаблицы, наследование и 
# математические операторы.
# Gem-пакет sass-rails был автоматически включен в наше приложение hello, так что мы можем прямо сейчас изменить
# визуальное представление примера, добавив что-нибудь в существующий SCSS-файл. Откройте файл app/assets/stylesheets/
# greetings.css.scss. В конец файла добавьте строки, которые изменят внешний вид списка приветствий:
body {
  font-family: "Avenir", "Helvetia Neue", Arial;
}

h1 {
  text-shadow: 2px 2px 5px rgba(150, 150, 150, 1);
}

ol {
  margin-left: 15px;
  li {
    margin-bottom: 10px;
  }
}
# Сохранив файл, проверьте, что сервер Rails работает, и перезагрузите страницу по адресу http://localhost:3000.
# Список приветствий будет выглядеть по-другому. Под заголовком "Greetings" появится светлая тень, а каждое 
# приветствие будет отделено от края страницы и от других приветствий промежутком.
# Код на SCSS, как и на CSS, состоит из селекторов и правил. Селекторы определяют, к каким HTML-тегам применяются
# правила, а правила описывают визуальные характеристики. В примере SCSS выше мы изменили шрифт, используемый
# внутри тега body (а это видимая часть страницы). Затем мы задали для тега h1 серую тень, которая выделяет и
# "приподнимает" такой текст на странице. И в последнем наборе правил мы задаем левое поле шириной 15 пикселей для
# каждого нумерованного списка (тег ol), а для каждого элемента такого списка (тег li) - нижнее поле высотой 10 пикселей.
# Изменения простые, но ясно показывают всю процедуру работы с таблицами стилей. Файлы, находящиеся в каталоге
# app/assets/stylesheets, транслируются в CSS, если необходимо (на основе того же соглашения о расширениях файлов,
# что и для шаблонов). Затем результирующие CSS-файлы отправляются клиентскому браузеру, который с их помощью изменяет
# визуальное представление HTML-разметки, пришедшей в теле ответа.
# Крис Эпштейн (Chris Eppstein), один из авторов Sass, разработал также Compass - библиотеку предопределенных правил,
# которые можно импортировать в SCSS-файлы. В Compass включен большой набор общеупотребительных правил, относящихся
# к межбраузерной совместимости, управлению макетом и типографике, а также правила, которые должны войти в CSS3,
# но пока поддерживаются не всеми браузерами. Дополнительные сведения о Compass см. на сайте compass-style.org.
# Даже без Compass процессор Sass - полезный и эффективный инструмент, который пригодится любому разработчику, 
# который занимается написанием и сопровождением CSS-стилей. Для получения дополнительных сведений о Sass начните
# с посещения сайта sass-lang.com. Отметим также, что существуют и другие препроцессоры CSS, помимо Sass, в частности
# Less и Stylus. Если Sass вам почему то не нравится, быть может, альтернативы покажутся более привлекательными.
# Разобравшись с тем, как в Rails обрабатываются таблицы стилей, перейдем к JavaScript.
# JavaScript и CoffeeScript
# С годами веб-приложения стали гораздо более сложными, функционально насыщенными и интерактивными. Из хорошо известных
# примеров так называемых "обагащенных клиентов" можно назвать Gmail и Google Docs, Microsoft Office365 и iWork
# для Cloud от Apple. Во всех них активно используется JavaScript-код для создания сайта, который, работая в браузере
# имитирует внешний вид и функциональные возможности сложного персонального приложения для Windows или Mac OS X.
# Для некоторых сайтов наличие такой развитой интерактивности - необходимое требование. Реагируя на эту тенденцию
# появилось множество JavaScript-каркасов, помогающих создавать приложения, характеризуемые большей интерактивностью.
# Одни каркасы ориентированы больше на богатство возможностей, другие на простоту работы. В качестве примера назовем
# Ember, Angular, React, Backbone и даже Batman.js, но отметим, что вообще-то их десятки и, похоже каждую неделю 
# появляется новый.
# Конвейер активов позволяет вклюить в приложение Rails одни или несколько JavaScript-библиотек. Для некоторых (например,
# Ember и Angular) приложение Rails играет роль JSON API, которое поставляет данные, необходимые JavaScript-приложению
# работающему внутри браузера. Для других (например React и Backbone) приложение Rails может отдавать данные в формате
# HTML, JSON или том и другом в зависимости от того, как написан код на Ruby и JavaScript. Более подробное обсуждение
# различных JSON API приведено в следующем разделе.

# Так же, как для SCSS имеется транслятор на CSS, так и для JavaScript существует популярный язык, транслируемый на 
# понятный браузерам JavaScript. Язык coffeeScript добавляет многое из того, чего, по мнению авторов, недостает 
# JavaScript, в том числе итераторы, исключение почти всех скобок, синтаксис создания функций и другое.
# Для демонстрации использования CoffeeScript в приложении Rails добавим код включения нового приветствия в список
# при каждом щелчке по заголовку "Greetings". Откройте файл app/assets/javascripts/greetings.js.coffee и добавьте
# в конец такие строки:
$('body').ready ->
    $('h1').click () ->
      $.ajax "/hello/Hilda?from=Rails",
        success: (data) ->
          item = $.parseHTML('<li>' + $(data).text() + '</li>')
          $('ol').append item
# JavaScript-код, получившийся в результате трансляции этого кода на CoffeeScript, можно посмотреть в браузере, 
# перейдя по адресу http://localhost:3000/assets/greetings.js, ниже он воспроизводится:
(function() {
  $('body').ready(function() {
    return $('h1').click(function(e) {
      return $.ajax("/hello/Hilda?from=Rails", {
        success: function(data) {
          var item;
          item = $.parseHTML('<li>' + $(data).text() + '</li>');
          return $('ol').append(item);
        }
      });
    });
  });
}).call(this);
# Здесь мы пользуемся JavaScrtipt-библиотекой jQuery (доступ к которой открывает переменная $), чтобы найти тег
# body, а затем предоставляем функцию, которая выполняется один раз, когда браузер закончит отрисовку и тело будет
# "готово". В этой функции мы находим тег h1 и передаем функцию, которая вызывается при щелчке по этому тегу. В ней
# предоставляемый jQuery метод ajax запрашивает конкретное приветствие, обращаясь к URL/hello, который мы реализовали
# раньше. Если обработка запроса завершилась успешно, то создается новый тег li, содержащий текст из тела ответа, 
# и этот тег добавляется в конец нумерованного списка ol. Явно этого не видно из кода, но если Ajax-запрос завершается
# неудачно, то ничего не происходит. Для обработки ошибок следовало бы предоставить функцию с ключом failure.
# Это очень простой пример совместного использования CoffeeScript и jQuery, но из него легко составить представление
# о том, чего можно достичь в приложении Rails с помощью конвейера активов. Есть много веб-приложений, которые начинали
# с таких же скромных шагов, а затем разрослись в гигантские монолитные приложения Rails, приносящие тысячи и даже 
# миллионы долларов дохода.
# Как видно даже из этого тривиального примера, CoffeeScript-код короче, проще и чище эквивалентного JavaScript-кода.
# Это различие проявляется тем нагляднее, чем больше объем кода - JavaScript оказывается заметно длиннее. Но у 
# CoffeeScript есть и недостатки. И самый существенный - тот факт, что CoffeeScript добавляет к JavaScript собственный
# цикл for и систему наследования на основе классов.
# Вы спросите, почему это недостаток? Потому что цикл for и наследование на основе классов запланированы к включению
# в следующую версию языка, известную под названием ECMAScript 6. ES6 (общепринятое сокращение) стремится устранить
# многие недостатки, из-за которых и был создан CoffeeScript, но способом, совместимым с существующим языком 
# JavaScript, а не радикально отличающимся от него.
# Как часто бывает в подобных ситуациях, существуют компромиссы, склоняющиеся как к одному, так и к другому подходу.
# Лично я перестал пользоваться CoffeeScript, когда понял, что он не обеспечит совместимость со следующей версией 
# JavaScript. Для других скорость разработки (а может быть, отсутствие лишних скобок) имеет большую ценность, для
# них CoffeeScript - несомненное благо.
# Желающие узнать больше о CoffeeScript могут зайти на сайт coffeescript.org.
# Что же касается изучения JavaScript, то я рекомендую справочные руководства и учебные пособия на сайте
# Mozilla Developer по адресу developer.mozilla.org/docs/Web/JavaScript.

-------------------------------------------------------------
Array.new(5) { Aray.new(4) { rand(0..9) } } # Создать массив 5 на 4 и заполнить весь массив абсолютно случайными значениями от 0 до 9.


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

# Имеется также метод open. В простейшей форме это просто синоним new:
trans = File.open("transactions", "w")
-----------------------------------------------------------------------------
# автоматическое закрытие файла с методом open
File.open("somefile", "w") do |file|
  file.puts "Строка 1"
  file.puts "Строка 2"
  file.puts "Третья и последняя строка"
end
# теперь файл закрыт

# Метод reopen ассоциирует с объектом-получателем новый поток. В примере ниже мы отключаем запись на
# стандартный вывод для ошибок, а затем снова включаем:
save = STDERR.dup
STDERR.reopen("/dev/null")
# Работаем молча...
STDERR.reopen(save)

-----------------------------------------------------------------------------
# обновление файла
# чтобы открыть файл для чтения и записи, достаточно добавить знак (+) в строку задания режима
f1 = File.new("file1", "r+")
# Чтение/запись, от начала файла.

f2 = File.new("file2", "w+")
# Чтение/запись; усечь существующий файл или создать новый.

f3 = File.new("file3", "a+")
# Чтение/запись; перейти в конец существующего файла или создать новый.

# Дописывание в конец файла. Чтобы дописать данные в конец существующего файла, нужно указать строку
# задания режима "а" (см. раздел 10.1.1)
logfile = File.open("captains_log", "a")
# Добавить строку в конец и закрыть файл.
logfile.puts "Stardate 47824.1: Our show has been canceled."
logfile.close

# Прямой доступ к файлу
# Для чтения из файла в произвольном порядке, а не последловательно, можно воспользоваться методом seek,
# который класс File наследует от IO. Проще всего перейти на байт в указанной позициию Номер позиции
# отсчитывается от начала файла, причем самый первый байт находится в позиции 0
# myfile содержит строку: abcdefghi
file = File.new("myfile")
file.seek(5)
str = file.gets                       # "fghi"

# Если все строки в файле имеют одинаковую длину, то можно перейти сразу в начало нужной строки:
# Предполагается, что все строки имеют длину 20.
# Строка N начинается с байта (N-1)*20
file = File.new("fixedlines")
file.seek(5*20)                        # Шестая строка!

# Для выполнения относительного поиска воспользуйтесь вторым параметром.
# Константа IO::SEEK_CUR означает, что смещение задано относительно текущей позиции (и может быть отрицательным):
file = File.new("somefile")
file.seek(55)                          # Позиция 55
file.seek(-22, IO::SEEK_CUR)           # Позиция 33
file.seek(47, IO::SEEK_CUR)            # Позиция 80

# Можно также искать относительно конца файла, в таком случае смещение может быть только отрицательным:
file.seek(-20, IO::SEEK_END)           # двадцать байтов от конца файла

# Есть еще и третья константа IO::SEEK_SET, но это значение по умолчанию (поиск относительно начала файла).
# Метод tell возвращает текущее значение позиции в файле, у него есть синоним pos:
file.seek(20)
pos1 = file.tell                       # 20
file.seek(50, IO::SEEK_CUR)            
pos2 = file.pos                        # 70
# Метод rewind устанавливает указатель файла в начало. Его название восходит ко временам использования лент.
# Для выполнения прямого доступа файл часто открывается в режиме обновления (для чтения и записи). Этот 
# режим обозначается знаком + в начале строки задания режима (см. раздел 10.1.2)

# Работа с двоичными файлами.
# В двоичном режиме можно читать байты и производить над ними такие манипуляции, которые
# при наличии кодировки были бы недопустимымы:
File.write("invalid", "\xFC\x80 \x80\x80\xAF")
File.read("invalid", mode: "r").split(" ")
# invalid byte sequence in UTF-8 недопустимая последовательность байтов в UTF-8
File.read("invalid", mode: "rb").split(" ")
# ["\xFC\x80", "\x80\xAF"]

# В Windows двоичный режим означает также, что пару символов r\n\(возврат каретки и перевод строки),
# завершающую строку, не следует преобразовывать в один символ \n.
# Еще одно важное отличие - интерпретация символа Ctrl+Z как конца файла в текстовом режиме:
# myfile содержит "12345\0326789\r".
# Обратите внимание на восьмеричное 032 (^Z)
File.open("myfile", "rb") {|f| str = f.sysread(15) }.size       # 11
File.open("myfile", "r") {|f| str = f.sysread(15) }.size        # 5

# В следующем фрагменте показано, что на платформе Windows символ возврата каретки не преобразуется в двоичном режиме:
# Входной файл содержит всего одну строку: Строка 1.
file = File.open("data")
line = file.readline                # "Строка 1.\n"
puts "#{line.size} символов."       # 10 символов
file.close

file = File.open("data", "rb") 
line = file.readline                # "Строка 1.\r\n"
puts "#{line.size} символов."       # 11 символов
file.close

# Отметим, что упомянутый в коде метод binmode переключает поток в двоичный режим.
# После переключения вернуться в текстовый режим невозможно.
file = File.open("data")
file.binmode
line = file.readline                # "Строка 1.\r\n"
puts "#{line.size} символов."       # 11 символов
file.close

# При необходимости выполнить низкоуровневый ввод-вывод можно воспользоваться методами sysread и syswrite.
# Первый принимает в качестве параметра число подлежащих чтению байтов, второй принимает строку и возвращает число
# написанных байтов.
input = File.new("infile")
output = File.new("outfile")
instr = input.sysread(10);
bytes = output.syswrite("Это тест.")
# Отметим, что метод sysread возбуждает исключение EOFError при попытке вызвать его, когда достигнут
# конец файла (но не в том случае, когда конец файла встретился в ходе успешной операции чтения).
# Оба метода возбуждают исключение SystemCallError при возникновении ошибки ввода-вывода.
# При работе с двоичными данными могут оказаться полезны метод pack из класса Array и метод unpack из класса String.

# Блокировка файлов.
# В тех операционных системах, которые поддерживают такую возможность, метод flock класса File блокирует и разблокирует файл.
# Вторым параметром может быть одна из констант File::LOCK_EX, File::LOCK_NB, File::LOCK_SH, File::LOCK_UN 
# или их объединение с помощью оператора ИЛИ. Понятно, что многие комбинации не имеют смысла,
# чаще всего употребляется флаг, задающий неблокирующий режим.
file = File.new("somefile")

file.flock(File::LOCK_EX)                 # Монопольная блокировка; никакой другой
                                          # процесс не может обратиться к другому файлу.
file.flock(File::LOCK_UN)                 # Разблокировать.

file.flock(File::LOCK_SH)                 # Разделяемая блокировка (другие
                                          # процессы могут сделать то же самое).

file.flock(File::LOCK_UN)                 # Разблокировать.

locked = file.flock(File::LOCK_EX  File::LOCK_NB)
# Пытаемся заблокировать файл, но не приостанавливаем программу, если
# не получилось; в таком случае переменная locked будет равна false.

# Простой ввод-вывод. 
# Кроме методов gets, puts, print, printf и p, есть еще метод putc.
# Метод putc выводит один символ
# Если параметроа является объект String, то печатается первый символ строки.
putc(?\n)           # Вывести символ новой строки
putc("X")           # Вывести букву X

# Весь вывод, формируемыц методами из Kernel направляется в глобальную переменную $stdout
# Она инициализирована значением STDOUT, так что данные отправляются на стандартный вывод.
# В любой момент переменной $stdout можно присвоить другое значение, являющееся объектом IO.
diskfile = File.new("foofile", "w")
puts "Привет..."                     # Выводится на stdout
$stdout = diskfile
puts "Пока!"                         # выводится в файл "foofile"
diskfile.close
$stdout = STDOUT                     # восстановление исходного значения
puts "Это все."                      # выводится на stdout
# Помимо метода gets, в модуле Kernel есть также методы ввода readline и readlines.
# Первый аналогичен gets в том смысле, что возбуждает исключение EOFError при попытке читать за концом
# файла, а не просто возвращает nil. Последний эквивалентет методу IO.readlines(то есть считывает весь файл в память).
# Откуда мы получаем ввод? Есть переменная $stdin, которая по умолчанию равна STDIN. Точно также
# существует поток стандартного вывода для ошибок ($stderr, по умолчанию равен STDERR).
# Еще имеется интересный глобальный объект ARGF, представляющий конкатенацию всех файлов, указанных
# в командной строке. Это не объект класса File, хотя и напоминает таковой. По умолчанию ввод связан
# именно с этим объектом, если в командной строке задан хотя бы один файл.
# cat.rb
# Прочитать все файлы, а затем вывести их
puts ARGF.read
# А при таком способе более экономно расходуется память:
puts ARGF.readline until ARGF.eof?
# Пример: ruby cat.rb file1 file2 file3

# Чтение из стандартного ввода (STDIN) происходит в обход методов Kernel. 
# Поэтому можно обойти (или не обходить) ARGF, как показано ниже:
# Прочитать строку из стандартного ввода
str1 = STDIN.gets
# Прочитать строку из ARGF
str2 = ARGF.gets
# А теперь снова из стандартного ввода
str3 = STDIN.gets

# Существует возможность читать как на уровне символов, так и на уровне байтов. 
# В случае однобайтовой кодировки разница только в том, что байт имеет тип Fixnum, а символ - это односимвольная строка:
c = input.getc
b = input.getbyte
input.ungetc                     # Эти две операции не всегда
input.ungetbyte                  # возможны.
b = input.readbyte               # Как getbyte, но может возбуждать EOFError

# Буферизованный и небуферизованный ввод-вывод
# В некоторых случаях Ruby осуществляет буферизацию самостоятельно. Рассмотрим следующий фрагмент:
print "Привет..."
sleep 10
print "Пока!\n"
# Если запустить программу, то можно увидеть, что сообщения "Привет" и "Пока" появляются одновременно, 
# после завершения sleep. При этом первое сообщение не завершается символом новой строки.
# Это можно исправить, вызвав метод flush для опустошения буфера ввода.
# В данном случае вывод идет в поток $defout (подразумеваемый по умолчанию для всех методов Kernel,
# которые занимаются выводом). И поведение оказывается ожидаемым, т.е. первое сообщение появляется раньше второго.
print "Привет... "
STDOUT.flush
sleep 10
print "Пока!\n"
# Буферизацию можно отключить (или включить) методом sync=, а метод sync позволяет узнать текущее состояние.
buf_flag = $defout.sync           # true
STDOUT.sync = false
buf_flag = STDOUT.sync            # false
# Есть также еще по крайней мере один низкий уровень буферизации, который не виден. Если метод getc
# возвращает символ и продвигает вперед указатель файла или потока, то метод ungetc возвращает символ назад в поток.
ch = mystream.getc                # ?A
mystream.ungetc(?C)
ch = mystream.getc                # ?C
# Тут следует иметь ввиду три вещи. Во-первых, только что упомянутая буферизация не имеет отношения
# к механизму буферизации, о котором мы говорили выше в этом разделе. Иными словами, предложение
# sync=false не отключает ее. Во-вторых, вернуть в поток можно только один символ, при попытке вызвать
# метод ungetc несколько раз будте возвращен только символ, прочитанный последним. И, в-третьих, 
# метод ungetc не работает для принципиально небуфиризуемых операций (например, sysread).

# Манипулирование правами владения и разрешениями на доступ к файлу.
# Для определения владельца и группы файла (это целые числа), класс File::Stat предоставляет методы экземпляра uid и gid:
data = File.stat("somefile")
owner_id = data.uid
group_id = data.gid
# В классе File::Stat есть также метод экземпляра mode, который возвращает текущий набор разрешений для файла.
perms = File.stat("somefile").mode
# В классе File имеется метод класса и экземпляра chown, который позволяет изменить идентификаторы владельца и группы.
# Метод класса принимает произвольное число файлов. Если идентификатор не нужно изменять, можно передать nil или -1.
uid = 201
gid = 10
File.chown(uid, "alpha", "beta")
f1 = File.new("delta")
f1.chown(uid, gid)
f2 = File.new("gamma")
f2.chown(nil, gid)                        # Оставить идентификатор владельца без изменения
# Разрешения можно изменить с помощью метода chmod (у него есть два варианта: метод класса и метод экземпляра).
# Традиционно разрешения представляют восьмеричным числом, хотя это и не обязательно.
File.chmod(0644, "epsilon", "theta")
f = File.new("eta")
f.chmod(0444)
# Процесс всегда работает от имени какого-то пользователя (возможно, root), поэтому с ним связан идентификатор пользователя
# (мы сейчас говорим о действующем идентификаторе пользователя). Часто нужно знать, имеет ли этот пользователь право читать,
# писать или исполнять данный файл. В классе File::Stat есть методы экземпляра для получения такой информации.
info = File.stat("/tmp/secrets")
rflag = info.readable?
wflag = info.writable?
xflag = info.executable?
# Иногда нужно отличить действующий идентификатор пользователя от реального. На этот случай предлагаются методы экземпляра
# readable_real?, writable_real? и executable_real?.
info = File.stat("/tmp/secrets")
rflag2 = info.readable_real?
wflag2 = info.writable_real?
xflag2 = info.executable_real?
# Можно сравнить владельца файла с действующим идентификатором пользователя (и идентификатором группы) текущего процесса.
# В классе File::Stat для этого есть методы owned? и grpowned?.
# Отметим, что многие из этих методов можно найти также в модуле FileTest:
rflag = FileTest::readable?("pentagon_files")
# Прочие методы: writable? executable? readable_real?
# writable_real? executable_real? owned? grpowned?
# Отсутствую здесь: uid gid mode

# Маска umask, ассоциированная с процессомм, определяет начальные разрешения для всех созданных им файлов.
# Стандартные разрешения 0777 логически пересекаются (AND) с отрицанием umask, то есть биты, поднятые в маске, "маскируются"
# или сбрасываются. Если вам удобнее, можете представлять себе эту операцию как вычитание (без занимания).
# Следовательно, если задана маска 022, то все файлы создаются с разрешениями 0755.
# Получить или установить маску можно с помощью метода umask класса File. Если ему передан параметр, то он становится
# новым значением маски (при этом метод возвращает старое значение).
File.umask(0237)                       # Установить umask
current_umask = File.umask             # 0237
# Некоторые биты режима файла (например, бит фиксации (sticky bit)) не имеют прямого отношенияя к разрешениям.

# Получение и установка временных меток
# Ruby понимает три таких метки: время модификации, время доступа и время изменения. Получить эту информацию можно тремя разными способами.
# Методы mtime, atime и ctime класса File возвращают временные метки, не требуя предварительного открытия или даже создания объекта File.
t1 = File.mtime("somefile")
# Thu Jan 04 09:03:10 GMT-6:00 2001
t2 = File.atime("somefile")
# Thu Jan 09 10:03:34 GMT-6:00 2001
t3 = File.ctime("somefile")
# Sun Nov 26 23:48:32 GMT-6:00 2000

# Если файл, представленный экземпляром File, уже открыт, то можно воспользоваться методами этого экземпляра.
myfile = File.new("somefile")
t1 = myfile.mtime
t2 = myfile.atime
t3 = myfile.ctime
# А если имеется экземпляр класса File::Stat, то и у него есть методы, позволяющие получить ту же информацию:
myfile = File.new("somefile")
info = myfile.stat
t1 = info.mtime
t2 = info.atime
t3 = info.ctime
# Отметим, что объект File::Stat возвращается методом класса (или экземпляра) stat из класса File. Метод класса lstat
# (или одноименный метод экземпляра) делает то же самое, но возвращает информацию о состоянии самой ссылки, а не файла,
# на который она ведет. Если имеется цепочка из нескольких ссылок, то метод следует по каждой из них, кроме последней.
# Для изменения времени доступа и модификации применяется метод utime, которому можно передать несколько файлов.
# Время можно создать в виде объекта Time или числа секунд, прошедших с точки отсчета.
today = Time.now
yesterday = today - 86400
File.utime(today, today, "alpha")
File.utime(today, yesterday, "beta", "gamma")
# Поскольку обе временные метки изменяются одновременно, то при желании оставить одну без изменения, ее сначала следует получить и сохранить.
mtime = File.mtime("delta")
File.utime(Time.now, mtime, "delta")

# Проверка существования и получение размера файла
# Часто необходимо знать, существует ли файл с данным именем. Это позволяет выяснить метод exist? из модуля FileTest:
flag = FileTest::exist?("LochNessMonster")
flag = FileTest::exists?("UFO")
# exists? является синонимом exist?

# Чтобы узнать есть ли в файле какие-нибудь данные, можно использовать метод zero?
# Метод zero? возвращает true, если длина файла равна нулю, и false в противном случае.
flag = File.new("somefile").stat.zero?
# Метод size? возвращает либо размер файла в байтах, если он больше нуля, либо nil для файла нулевой длины.
# Не сразу понятно, почему nil а не 0. Дело в том, то метод предполагалось использовать в качестве предиката,
# а значение истинности нуля в Ruby - true, тогда для nil оно равно false.
if File.size?("myfile")
  puts "В файле есть данные."
else
  puts "Файл пуст."
end
# Далее возникает вопрос: "Каков размер файла?". Мы уже видели, что для непустого файла метод size?
# возвращает длину. Но, если мы применяем его не в качестве предиката, то значение nil только путает.
# В классе File  для ответа на этот вопрос есть как метод класса, так и метод экземпляра:
size1 = File.size?("filename")                  # возвращает 0, если файл filename пуст
# Чтобы получить размер файла в блоках, а не в байтах, можно обратиться к методу blocks из класса File::Stat.
# Результат, конечно, зависит от операционной системы. (Метод blksize сообщает размер блока операционной системы.)
info = File.stat("somefile")
total_bytes = info.blocks * info.blksize

# Опрос специальных свойств файла
# У файла есть много свойств, которые можно опросить. 
# В некоторых операционных системах устройства подразделяются на блочные и символьные. Файл может ссылаться
# как на то, так и на другое, но не на оба сразу. Методы blockdev? и chardev? из модуля FileTest проверяют тип устройства:
flag1 = FileTest::chardev?("/dev/hdisk0")   # false
flag2 = FileTest::blockdev?("/dev/hdisk0")  # true
# Иногда нужно знать, ассоциирован ли данный поток с терминалом. Метод tty? класса IO (синоним isatty) дает ответ на этот вопрос:
flag1 = STDIN.tty?                          # true
flag2 = File.new("diskfile").isatty         # false
# Поток может быть связан с каналом (pipe) или сокетом. В модуле FileTest есть методы для опроса этих условий:
flag1 = FileTest::pipe?(myfile)
flag2 = FileTest::socket?(myfile)
# Напомним, что каталог - это частный случай файла. Поэтому нужно уметь отличать каталоги от обычных файлов, 
# для чего предназначены следующие два метода:
file1 = File.new("/tmp")
file2 = File.new("tmp/myfile")
test1 = file1.directory?                    # true
test2 = file.file?                          # false
test3 = file2.directory?                    # false
test4 = file2.file?                         # true
# В классе File есть также метод класса ftype, который сообщает вид потока, одноименный метод экземпляра
# находится в классе File::Stat. Этот метода возвращает одну из следующих строк:file, directory, blockSpecial,
# characterSpecial, fifo, link или socket(строка fifo относится к каналу).
this_kind = File.ftype("/dev/hdisk0")       # "blockSpecial"
that_kind = File.new("/tmp").stat.ftype     # "directory"
# В маске, описывающей режим файла, можно устанавливать или сбрасывать некоторые биты. Они не имеют прямого
# отношения к битам, обсуждавшимся в разделе 10.1.9. Речь идет о битах set-group-id, set-user-id, и бите
# фиксации (sticky bit). Для каждого из них есть свой метод.
file = File.new("somefile")
sticky_flag = file.sticky?
setgid_flag = file.setgid?
setuid_flag = file.setuid?
# На дисковый файл могут вести символические или физические ссылки (в тех операционных системах, где такой
# механизм поддерживается). Чтобы проверить, является ли файл символической ссылкой на другой файл, обратитесь
# к методу symlink?. Для подсчета числа физических ссылок на файл служит метод nlink (он есть только в классе File::Stat).
# Физическая ссылка не отличима от обычного файла, это просто файл, для которого есть несколько имен и записей в каталоге.
File.symlink("yourfile", "myfile")             # Создать ссылку
is_sym = File.symlink?("myfile")               # true
hard_count = File.new("myfile").stat.nlink     # 0
# Отметим попутно, что в предыдущем примере мы воспользовались методом класса symlink из класса File
# для создания символической ссылки.
# В редких случаях может понадобиться информация о файле еще более низкого уровня. В классе File::Stat есть
# еще три метода экземпляра, представляющих такую информацию. Метод dev возвращает целое число, идентифицирующее
# устройство, на котором расположен файл. Метод rdev возвращает целое число, описывающее тип устройства, 
# а для дисковых файлов метод ino возвращает номер первого индексного узла, занятого файлом.
file = File.new("diskfile")
info = file.stat 
device = info.dev
devtype = info.rdev
inode = info.ino
------------------------------------------------------------------------------
# Каналы
# Ruby поддерживает разные способы читать из канала и писать в него. Метод класса IO.popen открывает канал
# и связывает с возвращенным объектом стандартные ввод и вывод процесса. Часто с разными концами канала работают
# разные потоки, но в примере ниже запись и чтение осуществляет один и тот же поток:
check = IO.popen("spell", "r+")
check.puts("T was brillig, and the slithy toves")
check.puts("Did gyre and gimble in the wabe.")
check.close_write
list = check.readlines
list.collect! { |x| x.chomp }
# list равно %w[brillig gimble gyre slithy toves wabe]
# Отметим, что вызов close_write обязателен, иначе мы никогда не достигнем конца файла при чтении из канала.
# Существует также блочная форма:
File.popen("/usr/games/fortune") do |pipe|
  quote = pipe.gets
  puts quote
  # На чистом диске можно искать бесконечно. - Том Стил
end
#  Если задана строка "-", то запускается новый экземпляр Ruby. Если при этом задан еще и блок, то он работает
# в двух разных процессах, как в результате разветвления (fork); блоку в процессе-потомке передается nil, 
# а в процессе-родителе объект iO, с которым связан стандартный ввод или стандартный вывод.
IO.popen("-") do |mypipe|
  if mypipe
    puts "Я родитель: pid = #{Process.pid}"
    listen = mypipe.gets
    puts listen
  else
    puts "Я потомок: pid = #{Process.pid}"
  end
end

# Печатается:
# Я родитель: pid = 10580
# Я потомок: pid = 10582

# Метод pipe возвращает также два конца канала, связанных между собой. В следующем примере мы создаем два потока,
# один из которых передает сообщение другому (то самое сообщение, которое Сэмьюел Морзе послал по телеграфу).
pipe = IO.pipe
reader = pipe[0]
writer = pipe[1]

str = nil
thread1 = Thread.new(reader,writer) do |reader,writer|
  # writer.close_write
  str = reader.gets
  reader.close
end

thread2 = Thread.new(reader,writer) do |reader,writer|
  # reader.close_read
  writer.puts("What hath God wrougth?")
  writer.close
end

thread1.join
thread2.join

puts str                 # What hath God wrought?

# Неблокирующий ввод-вывод
string = input.read(64)                    # читать 64 байта
buffer = ""
input.read(64, buffer)                     # необязательный буфер
# По достижении конца файла возбуждается исключение EOFError. Если возникло исключение EWOULDBLOCK, то
# в следующий раз метод можно вызывать только после того, как станут доступны данные. Например:
begin
  data = input.read_nonblock(256)
rescue Errno::EWOULDBLOCK
  IO.select([input])
  retry
end
# Аналогично метод write_nonblock обращается к системному вызову write(2) (и возбуждает соответствующие исключения).
# Он принимает в качестве аргумента строку и возвращает количество записанных байтов (которое может оказаться
# меньше длины строки). Исключение EWOULDBLOCK следует обрабатывать так же, как в случае описанного выше метода read_nonblock

# Применение метода readpartial
# Метод readpartial упрощает ввод-вывод в поток, например в сокет.
# Параметр "максимальная длина" (max length) обязателен. Если задан параметр buffer, то он должен ссылаться на строку, в которой будут храниться данные.
data = sock.readpartial(128)              # Читать не более 128 байтов

# Манипулирование путевыми именами
# Основными методами для работы с путевыми именами являются методы класса File.dirname и File.basename;
# они работают, как одноименные команды UNIX, то есть возвращают имя каталога и имя файла соответственно.
# Если вторым параметром методу basename передана строка с расширением имени файла, то это расширение исключается.
str = "/home/dave/podbay.rb"
dir = File.dirname(str)                     # "/home/dave"
file1 = File.basename(str)                  # "podbay.rb"
file2 = File.basename(str, ".rb")           # "podbay"
# Хотя это методы класса File, на самом деле они просто манипулируют строками.
# Упомянем также метод File.split, который возвращает обе компоненты (имя каталога и файла) в массиве из двух элеметов:
info = File.split(str)                      # ["/home/dave/","podbay.rb"]
# Метод класса expand_path преобразует относительное путевое имя в абсолютный путь.
# Если операционная система понимает сокращения ~ и ~user, то они тоже учитываются.
# Необязательный второй аргумент задает путь, начиная от которого следует производить расширение; часто
# в этом качестве указывают путь к текущему каталогу __FILE__.
Dir.chdir("/home/poole/personal/docs")
abs = File.expand_path("../../misc")                # "/home/poole/misc"
abs = File/expand_path("misc", "/home/poole")       # "/home/poole/misc"
# Если передать методу экземпляра path открытый файл, то он вернет путевое имя, по которому файл открыт.
File.new("../../foobar").path                       # "../../foobar"
# Константа File::Separator равна символу, применяемому для разделения компонентов путевого имени (в Windows
# это обратная косая черта, а в UNIX - прямая косая черта). Имеется синоним File::SEPARATOR
# Метод класса join использует этот разделитель для составления полного путевого имени из переданного списка компонентов:
path = File.join("usr", "local", "bin", "someprog")
# path равно "usr/local/bin/someprog"
# Обратите внимание, что в начале имени разделитель не добавляется!
# Не думайте, что методы File.join и File.split взаимно обратны. Это не так.

# Класс Pathname
# Следует знать о стандартной библиотеке pathname, которая предоставляет класс Pathname.
# По существу, это обертка вокруг классов Dir, File и FileUtils, поэтому он комбинирует многие их 
# функции логичным и интуитивно понятным способом.
path = Pathname.new("/home/hal")
file = Pathname.new("file.txt")
p2 = path + file

path.directory?                      # true
path.file?                           # false
p2.directory?                        # false
p2.file?                             # true

parts = path2.split                  # [Pathname:/home/hal, Pathname:file.txt]
ext = path2.etxname                  # .txt
# Также имеется ряд вспомогательных методов. Метод root? пытается выяснить, относится ли данный путь к корневому каталогу,
# но его можно "обмануть", так как он просто анализирует строку, не обращаясь к файловой системе.
# Метод parent? возвращает путевое имя родительского каталога данного пути. Метод children возвращает
# непосредственных потомков каталога, заданного своим путевым именем, в их число включаются как файлы,
# так и каталоги, но рекурсивного спуска не производится.
p1 = Pathname.new("//")              # странно, но допустимо
p1.root?                             # true
p2 = Pathname.new("/home/poole")
p3 = p2.parent                       # Путевое имя:/home
items = p2.children                  # массив объектов Pathname (все файлы и каталоги, находящиеся непосредственно в каталоге poole)
# Как и следовало ожидать, методы relative и absolute пытаются определить, является ли путь относительным
# или абсолютным (проверяя, есть ли в начале имени косая черта):
p1 = Pathname.new("/home/dave")
p1.absolute?                         # true
p1.relative?                         # false
# Многие методы. например size, unlink и прочие, просто делегируют работу классам File и FileUtils;
# повторно функциональность не реализуется.

# Манипулирование файлами на уровне команд
# Часто приходится манипулировать файлами так, как это делается с помощью командной строки: копировать, удалять и т.д.
# Многие из этих операций реализованы встроенными методами, некоторые находятся в модуле FileUtils из библиотеки fileutils.
# Имейте в виду, что раньше функциональность модуля FileUtils подмешивалась прямо в класс File, 
# теперь эти методы помещены в отдельный модуль.
# Для удаления файла служит метод File.delete или его синоним File.unlink:
File.delete("history")
File.unlink("toast")
# Переименовать файл позволяет метод File.rename:
File.rename("Ceylon", "SriLanka")
# Создать ссылку на файл (физическую или символическую) позволяют методы File.link и File.symlink соответственно:
File.link("/etc/hosts", "/etc/hostfile")                   # физическая ссылка
File.symlink("/etc/hosts", "/tmp/hosts")                   # символическая ссылка
# Файл можно усечь до нулевой длины (или до любой другой), воспользовавшись методом экземпляра truncate:
File.truncate("myfile", 1000)                # Теперь не более 1000 байтов
# Два файла можно сравнить с помощью метода compare_fille. У него есть синонимы cmp и compare_stream:
require "fileutils"

same = FileUtils.compare_file("alpha", "beta")      # true
# Метод copy копирует файл в другое место, возможно, с переименованием. У него есть необязательный файл, 
# говорящий, что сообщения об ошибках нужно направлять на стандартный вывод для ошибок. Синоним - привычное
# для программистов UNIX имя cp.
require "fileutils"

# Скопировать файл epsilon в theta с протоколированием ошибок.
FileUtils.copy("epsilon", "theta", true)
# Файл можно перемещать методом move (синоним mv). Как и copy, этот метод имеет необязательный параметр, включающий вывод сообщений об ошибках.
FileUtils.move("/tmp/names", "/etc")                # Переместить в другой каталог
FileUtils.move("colours", "colors")                 # Просто переименовать

# Метод safe_unlink удаляет один или несколько файлов, предварительно пытаясь сделать их доступными
# для записи, чтобы избежать ошибок. Если последний параметр равен true или false, он интерпретируется как флаг,
# задающий режим вывода сообщений об ошибках.
require "fileutils"

FileUtils.safe_unlink("alpha", "beta", "gamma")
# Протоколировать ошибки при удалении следующих двух файлов
FileUtils.safe_unlink("delta", "epsilon", true)

# Наконец, метод install делает практически то же, что syscopy, но снаала проверяет, что целевой файл либо
# не существует, либо содержит такие же данные.
require "fileutils"

FileUtils.install("foo.so", "/usr/lib")
# Существующий файл foo.so не будет перезаписан, если он не отличается от нового.

# Ввод символов с клавиатуры
# В данном случае мы имеем в виду небуферизованный ввод, когда символ обрабатывается сразу после нажатия клавиши,
# не дожидаясь, пока будет введена вся строка.
# Это можно сделать и в UNIX, и в Windows, но, к сожалению, совершенно по разному.
# Версия для UNIX прямолинейна. Мы переводим терминал в режим прямого ввода (raw mode) и обычно одновременно отключаем эхо-контроль.
def getchar
  system("stty raw -echo")         # Прямой ввод без эхо-контроля
  char = STDIN.getc
  system("stty -raw echo")         # Восстановить режим терминала
  char
end
# На платформе Windows придется написать расширение на C. Альтернативой является использование одной
# из функций в библиотеке Win32API.
require 'Win32API'

def getchar
  char = Win32API.new("crtdll", "_getch", [], 'L').call
end
# Поведение в обоих случаях идентично.

# Чтение всего файла в память
# Чтобы прочитать весь файл в массив, не нужно его даже предварительно открывать. 
# Все сделает метод IO.readlines: откроет файл, прочитает и закроет.
arr = IO.readlines("myfile")
lines = arr.size
puts "myfile содержит #{lines} строк."

longest = arr.collect {|x| x.length}.max
puts "Самая длинная строка содержит #{longest} символов."
# Можно также воспользоваться методом IO.read (который возвращает одну большую строку, а не массив строк).
str = IO.read("myfile")
bytes = arr.size 
puts "myfile содержит #{bytes} байтов."

longest=str.collect {|x| x.length}.max    # строки - перечисляемые объекты!
puts "Самая длинная строка содержит #{longest} символов."
# Поскольку класс IO является предком File, то можно вместо этого написать File.readlines и File.read.

# Построчное чтение из файла
# Чтобы читать по одной строке из файла, можно обратиться к методу класса IO.foreach или методу экземпляра each.
# В первом случае файл не нужно явно открывать.
# Напечатать все строки, содержащие слово "target"
IO.foreach("somefile") do |line|
  puts line if line =~ target
end

# Другой способ...
file = File.new("somefile")
file.each do |line|
  puts line if line =~ /target/
end
# Отметим, что each_line - синоним each. Он также позволяет получить перечислитель:
lines = File.new("somefile").each_line
lines.find{|line| line =~ /target/}        # Используется как перечислитель

# Побайтное и посимвольное чтение из файла
# Для чтения из файла по одному байту служит метод экземпляра each_byte.
# Он передает в блок один байт (то есть объект типа Fixnum из диапазона 0..255):
a_count = 0
File.new("myfile").each_byte do |byte|
  a_count += 1 if byte == 97            # строчная буква в коде ASCII
end
# Можно читать также посимвольно (символ - это в действительности односимвольная строка).
# В зависимости от используемой кодировки символ может состоять из одного байта (как в ASCII) или из нескольких.
a_count = 0
File.new("myfile").each_char do |char|
  a_count += 1 if char == "a"
end
# Метод each_char также возвращает обычный перечислитель.

# Работа со строкой как с файлом
# Иногда возникает необходимость рассматривать строку как файл. Что под этим понимается, зависит от конкретной задачи.
# Oбъект определяется, прежде всего, своими методами. В следующем фрагменте показано, как к объекту source
# применяется итератор; на каждой итерации выводится одна строка. Можете ли вы что-нибудь сказать о типе 
# объекта source, глядя на этот код?
source.each do |line|
  puts line
end
# Это мог бы быть как файл, так и строка, содержащая внутри символы новой строки. В таких случаях строку
# можно трактовать как файл без всякого труда.
# Класс StringIO представляет многие методы класса IO, которых нет у обычной строки.
# В нем есть метод доступа string, ссылающийся на содержимое самой строки.
ios = StringIO.new("abcdefghijkl\nABC\n123")

ios.seek(5)
ios.puts("xyz")
puts ios.tell                    # 9
puts ios.string.inspect          # "abcdexyz\njkl\nABC\n123"

puts ios.getc                    # j
ios.ungetc(?w)                  
puts ios.string.inspect          # "abcdexyz\nwkl\nABC\n123"

s1 = ios.gets                    # "wkl"
s2 = ios.gets                    # "ABC"

# Копирование потока
# Метод класса copy_stream служит для копирования потока. Все данные копируются из начального объекта в конечный.
# Начальный и конечный объекты могут быть объектами IO или именами файлов. Третий (необязательный) параметр -
# количество подлежащих копированию байтов (по умолчанию, естественно, предполагается, что нужно копировать все байты из источника).
# Четвертый параметр - смещение от начала источника (в байтах):
src = File.new("garbage.in")
dst = File.new("garbage.out")
IO.copy_stream(src, dst)

IO.copy_stream("garbage.in", "garbage.out", 1000, 80)
# В конечный поток копируется 1000 байтов, начиная со смещения 80

# Чтение данных, встроенных в текст программы
# Распечатать все строки "задом наперед"...
DATA.each_line do |line|
  puts line.reverse
end
__END__
A man, a plan, a canal... Panama!
Madam, I'm Adam.
,siht gnidaer er'uoy fI 
.evisserpmi si noitacided ruoy

# Чтение исходного текста программы
# Глобальная константа DATA - это объект класса IO, ссылающийся на данные, которые расположены после 
# директивы __END__. Но, если выполнить метод rewind, то указатель файла будет переустаановлен на начало текста программы.
# Следующая программа  выводит собственный текст, снабжая его номерами строк. Это не очень полезно, но, 
# быть может, вы найдете и другие применения такой техники.
DATA.rewind
DATA.each_line.with_inde do |line, i|
  puts "#{'%03d' % (i + 1)} #{line.chomp}"
end
__END__
# Отметим, что наличие директивы __END__ обязательно, без нее к константе DATA вообще нельзя обратиться.
# Другой способ прочитать исходный текст текущего файла - воспользоваться специальной переменной __FILE__.
# Она содержит полный путь к самому файлу, и из нее можно читать:
puts File.read(__FILE__)

# Получение и изменение текущего каталога
# Получить имя текущего каталога можно с помощью метода Dir.pwd (синоним Dir.getwd).
# Эти имена уже давно употребляются как сокращения от "print working directory"(печатать рабочий каталог)
# и "get working directory" (получить рабочий каталог).
# Для изменения текущего каталога служит метод Dir.chdir. В Windows в начале строки можно указывать букву диска.
Dir.chdir("/var/tmp")
puts Dir.pwd                   # "/var/tmp"
puts Dir.getwd                 # "/var/tmp"
# Этот метод также принимает блок в качестве параметра. Если блок задан, то текущий каталог изменяется только
# на время выполнения блока, а потом восстанавливается в первоначальное значение:
Dir.chdir("/home")
Dir.chdir("/tmp") do
  puts Dir.pwd                 # /tmp
  # какой то код...
end
puts Dir.pwd                   # /home

# Изменение текущего корня
# В большинстве систем UNIX можно изменить "представление" процесса о том, что такое корневой каталог /.
# Обычно это делается из соображений безопасности перед запуском небезопасной или непротестированной программы.
# Метод chroot делает указанный каталог новым корнем:
Dir.chdir("/home/guy/sandbox/tmp")
Dir.chroot("/home/guy/sandbox")
puts Dir.pwd                    # "/tmp"

# Обход каталога
# Метод foreach - это итератор, который последовательно передает в блок каждый элемент каталога.
# Точно так ведет себя метод экземпляра each.
Dir.foreach("/tmp") { |entry| puts entry }

dir = Dir.new("/tmp")
dir.each { |entry| puts entry }
# Оба фрагмента печатают одно и то же (имена всех файлов и подкаталогов в каталоге /tmp).

# Получение содержимого каталога
# Метод класса Dir.entries возвращает массив, содержащий все элементы указанного каталога:
list = Dir.entries("/tmp")            # w%[. .. alpha.txt beta.doc]
# Как видите, включаются и элементы, соответствующие текущему и родительскому каталогу. Если они вам не
# нужны, придется отфильтровать вручную.

# Создание цепочки каталогов
# Иногда необходимо создать глубоко вложенный каталог, причем промежуточные каталоги могут и не существовать.
# В UNIX мы воспользовались бы для этого командой mkdir -p
# В программе на Ruby такую операцию выполняет метод FileUtils.makedirs (из библиотеки fileutils):
require "fileutils"
FileUtils.makedirs("/tmp/these/dirs/need/not/exist")

# Рекурсивное удаление каталога
# В UNIX команда rm -rf dir удаляет все поддерево, начиная с каталога dir.
# Понятно, что применять ее надо с осторожностью.
# В классе Pathname имеется метод rmtree, решающий ту же задачу.
require 'pathname'
dir = Pathname.new("/home/poole/")
dir.rmtree
# В классе FileUtils есть метод rm_r, который делает то же самое:
require 'fileutils'
FileUtils.rm_r("/home/poole")

# Работа с временными файлами
# Для работы с временными файлами имеется библиотека Tempfile.
# Метод new (синоним open) принимает базовое имя в качестве начального значения и конкатенирует его с 
# идентификатором процесса и уникальным порядковым номером. Необязательный второй параметр - имя каталога
# в котором создается временный файл, по умолчанию оно равно значению первой из существующих переменных 
# окружения TMPDIR, TMP, или TEMP, а если ни одна из них не задана, то "/tmp".
# Возвращаемый объект IO можно многократно открывать и закрывать на протяжении времени работы программы,
# а по завершении временный файл будет автоматически удален.
# У метода close есть необязательный флаг, если он равен true, то файл удаляется сразу после закрытия
# (не дожидаясь завершения программы). Метод path возвращает полное имя файла, если оно вам по какой то причине понадобится.
require "tempfile"

temp = Tempfile.new("stuff")
name = temp.path                       # "/tmp/stuff17060.0"
temp.puts "Здесь был Вася"
temp.close

# Позже...
temp.open
str = temp.gets                        # "Здесь был Вася"
temp.close(true)                       # Удалить СЕЙЧАС

# Поиск файлов и каталогов
# В класе Dir имеется метод glob (синоним []), возвращающий массив файлов, имена которых соответствуют 
# заданной маске в смысле оболочки. В простых случаях этого достаточно для поиска нужного фала в каталоге:
Dir.glob("*.rb")                       # все файлы ruby в текущем каталоге
Dir["spec/**/*_spec.rb"]               # все файлы с именами, заканчивающимися на _spec.rb в каталоге spec/

# Для более сложных случаев имеется стандартная библиотека find, которая позволяет посетить каждый файл
# в указанном каталоге и всех его подкаталогах. Следующий метод находит в указанном каталоге файлы по имени
# (строке) либо регулярному выражению.
require "find"

def findfiles(dir, name)
  list = []
  Find.find(dir) do |path|
    Find.prune if [".",".."].incude? path
    case name
      when String
        list << path if File.basename(path) == name
      when Regexp
        list << path if File.basename(path) =~ name
      else
        raise ArgumentError
      end
    end
    list
  end

  findfiles "/home/hal", "toc.txt"
  # ["/home/hal/docs/toc.txt", "/home/hal/misc/toc.txt"]

  findfiles "/home", /^[a-z]+.doc/
  # ["/home/hal/docs/alpha.doc", "/home/guy/guide.doc", "/home/bill/help/readme.doc"]

  # Доступ к данным более высокого уровня
  # Простой маршаллинг
  # Простейший способ сохранить объект для последующего использования - подвергнуть его маршалингу.
  # Модуль Marshal позволяет сериализовать и десериализовать объекты в Ruby, представив их в виде строк,
  # которые уже можно записать в файл.
  # массив элементов [composer, work, minutes]
  works = [["Leonard Bernstein", "Overture to Candide", 11],
           ["Aaron Copland", "Symphony No. 3", 45],
           ["Jean Sibelius", "Finlandia", 20]]
  # Мы хотим сохранить его для дальнейшего использования...
  File.write "store", Marshal.dump("works")

  # Намного позже...
  works = Marshal.load File.read("store")
  
  # Первые два байта данных, порождаемых методом Marshal.dump - номер старшей и младшей версии.
  Marshal.dump("foo").bytes[0..1]  # [4, 8]
  # Ruby успешно загружает такие данные только в том случае, когда номера старших версий данных и метода
  # совпадают, и номер младшей версии данных не больше младшей версии метода.

  # "Глубокое копирование" с помощью метода Marshal
  # В Ruby нет операции "глубокого копирования". Например, методы dup и clone хэша не копируют ключи и 
  # значения, на которые в хэше есть ссылки. Если количество вложенных ссылок на объекты достаточно велико,
  # то операция копирования превращается в игру "собери палочки".
  # Ниже предлагается способ реализовать глубокое копирование с некоторыми ограничениями, обусловленными
  # тем, что наш подход основан на использовании класса Marshal со всеми присущими ему недостатками:
  def deep_copy(obj)
    Marshal.load(Marshal.dump(obj))
  end

  a = deep_copy(b)

  # Более сложный маршалинг
  # Иногда мы хотим настроить маршалинг под свои нужды. Для этого нужно создать методы marshal_load 
  # и marshal_dump. Если они существуют, то вызываются во время выполнения маршалинга, чтобы мы могла самостоятельно
  # реализовать преобразование данных в строку и обратно.
  # В следующем примере человек получает 5-процентный доход на начальный капитал с момента рождения. Мы
  # не храним ни возраст, ни текущий баланс, поскольку они являются функциями времени.
  class personal
    attr_reader :balance, :name
    
    def initialize(name, birthday, beginning)
      @name = name
      @birthdate = birthdate
      @deposit = deposit
      @age = (Time.now - @birthdate) / (365*86400)
      @balance = @deposit * (1.05 * @age)
    end

    def age
      @age.floor
    end

    def marshal_dump
      {name: @name, birthdate: @birthdate, deposit: @deposit}
    end

    def marshal_load(data)
      initialize(data[:name], data[:birthdate], data[:deposit])
    end
  end

  p1 = Person.new("Rudy", Time.now - (14 * 365 * 86400), 100)
  [p1.name, p1.age, p1.balance]         # ["Rudy", 14, 197.9931599439417]

  p2 = Marshal.load Marshal.dump(p1)
  [p2.name, p2.age, p2.balance]         # ["Rudy", 14, 197.9931599440351]
  # При сохранении объекта этого типа атрибуты age и balance не сохраняются. А когда объект восстанавливается
  # они вычисляются заново. Отметим, что метод marshal_load предполагает, то объект существует; это один
  # из немногих случаев, когда метод initialize приходится вызывать явно (обычно это делает метод new).
  
  # Маршалинг в формате YAML
  # Аббревиатура YAML означает "YAML Ain't Markup Language" (YAML - не язык разметки).
  # Это не что иное, как гибкий, понятный человеку формат обмена данными между программами, возможно, 
  # написанными на разных языках.
  # Если загружена библиотека yaml, то в нашем распоряжении оказываются методы YAML.dump и YAML.load, 
  # очень похожие на соответствующие методы из класса Marshal. Было бы поучительно сериализовать несколько
  # объектов в формате YAML и посмотреть, что получается:
  require 'yaml'

  Person = Struct.new(:name)

  puts YAML.dump("Hello, world.")
  puts YAML.dump({this: "is a hash",
        with: "symbol keys and string values"})
  puts YAML.dump([1, 2, 3])
  puts YAML.dump Person.new("Alice")

  # Выводится:
  # --- Hello, world.
  # ...
  # ---
  # :this: is a hash
  # :with: symbol keys and string values
  # ---
  # - 1
  # - 2
  # - 3
  # --- !ruby/struct:Person
  # name: Alice
  
  # Любой YAML-документ начинается строкой "---", за которой следуют сериализованные объекты в понятном человеку виде.
  # Использовать метод YAML.load для загрузки строки столь же просто. А метод YAML.load_file идет на шаг 
  # дальше и позволяет указать имя загружаемого файла. Пусть имеется такой файл data.yaml:
  ---
  - "Hello, world"
  - 237
  -
    - Jan
    - Feb
    - Mar
    - Apr
  -
    just a: hash.
    This: is
  # Это четыре элемента данных, сгруппированные в единый массив. Если загрузить этот файл, то получится массив:
  require 'yaml'
  p YAML.load_file("data.yaml")
  # Выводится:
  # ["Hello, world", 237, ["Jan", "Feb", "Mar", "Apr"],
  #  {"just a"=>"hash.", "This"=>"is"}]
  # В общем и целом, YAML - еще один способ выполнить маршалинг объектов. На верхнем уровне его можно
  # использовать для самых разных целей. Например, человек может не только читать данные в этом формате, 
  # но и редактировать их, поэтому его естественно применять для записи конфигурационных файлов и т.п.
  # Поскольку библиотека YAML умееет выполнять маршалинг объектов Ruby, к ней относятся высказанные ранее
  # предостережения. Никогда не загружайте YAML-файлы, полученные из внешнего источника. Однако метод
  # YAML.safe_load допускает загрузку не всех классов, поэтому его можно без опаски использовать для загрузки
  # данных из ненадежных источников.
  # YAML позволяет и многое другое, о чем мы не можем здесь рассказать. Дополнительную информацию см.
  # документацию по библиотеке Ruby stdlib или официальный сайт yaml.org.
  
  # Сохранение данных с помощью библиотеки JSON
  # Хотя акроним JSON означает "JavaScript Object Notation" (объектная нотация в JavaScript), в этом формате
  # можно представить в понятном человеку виде данные, составленные из нескольких простых типов, имеющихся
  # практически в каждом языке программирования.
  # В силу своей простоты и широкой распространенности JSON стал основным форматом для передачи данных
  # между программами в Интернете.
  # Стандартная библиотека JSON используется почти также, как YAML. Сериализовать можно только хэши, массивы,
  # числа, строки, а также значения true, false, nil. Объект любого другого класса будет преобразован в строку:
  require 'json'

  data = {
         string: "Hi there",
         array: [1, 2, 3],
         boolean: true,
         object: Object.new
  }

  puts JSON.dump(data)
  # Выводится: {"string":"Hi there", "array":[1,2,3],
  #             "boolean":true, "object":"#<Object:0x007fd61b890430>"}

  # Для преобразования объектов Ruby в формат JSON и обратно необходимо написать код по аналогии с рассмотренными
  # выше методами marshal_dump и marshal_load. Существует соглашение, берущее начало в Ruby on Rails, 
  # о реализации метода as_json для преобразования объекта в типы данных, поддерживаемые JSON.
  
  # Вот так можно реализовать метод as_json для преобразования объекта Person в формат JSON и обратно:
  require 'json'
  require 'time'

  class Person
    # остальные методы не изменились...

    def as_json
      {name: @name, birthdate: @birthdate.iso8601, deposit: @deposit}
    end

    def self.from_json(json)
      data = JSON.parse(json)
      birthdate = Time.parse(data["birthdate"])
      new(data["name"], birthdate, data["deposit"])
    end
  end

  p1 = Person.new("Rudy", Time.now - (14 * 365 * 85400, 100)
  p1.as_json      # {:name=>"Rudy", :deposit=>100,
                  # :birthdate=>"2000-07-23T23:25:02-07:00"}

  p2 = Person.from_json JSON.dump(p1.as_json)
  [p2.name, p2.age, p2.balance]      # ["Rudy", 14, 197.9931600356966]
  # Поскольку JSON не позволяет сохранять объекты типа Time, мы преобразуем их в строку методом iso8601,
  # а затем - при создании нового объекта Person - восстанавливаем из этой строки объект Time.
  # Как уже было показано, библиотека JSON не поддерживает сериализацию объектов Ruby, в отличие от Marshal
  # и YAML. А значит, можно без опаски вызывать метод JSON.load для загрузки JSON-документов из ненадежных
  # источников, что позволяет использовать JSON для обмена данными с системами, которые вы не контролируете.

  # Работа с данными в формате CSV
  # Начнем с создания файла. Чтобы вывести данные, разделенные запятыми, мы просто открываем файл для записи;
  # метод open передает объект-писатель в блок. Затем с помощью оператора добавления мы добавляем массивы данных
  # (при записи они преобразуются в формат CSV). Первая строка является заголовком.
  require 'csv'

  CSV.open("data.csv", "w") do |wr|
    wr << ["name", "age", "salary"]
    wr << ["mark", "29", "34500"]
    wr << ["joe", "42", "32000"]
    wr << ["fred", "22", "22000"]
    wr << ["jake", "25", "24000"]
    wr << ["don", "32", "52000"]
  end
  # В результате исполнения этого кода мы получаем такой файл data.csv:
  "name", "age", "salary"
  "mark", 29, 34500
  "joe", 42, 32000
  "fred", 22, 22000
  "jake", 25, 24000
  "don", 32, 52000
  # Другая программа может прочитать этот файл:
  require 'csv'
  
  CSV.open('data.csv', 'r') do |row|
    p row
  end

  # Выводится:
  # ["name", "age", "salary"]
  # ["mark", "29", "34500"]
  # ["joe", "42", "32000"]
  # ["fred", "22", "22000"]
  # ["jake", "25", "24000"]
  # ["don", "32", "52000"]
  # Этот фрагмент можно было бы записать и без блока, тогда метод open просто вернул бы объект-читатель. 
  # Затем можно было бы вызвать метод shift читателя (как если бы это был массив) для получения очередной строки.
  # Но блочная форма мне представляется более естественной.
  # Каким бы способой ни был создан CSV-файл, его можно загрузить в Excel и другие электронные таблицы и там модифицировать.
  
  # SQLite3 как SQL-хранилище данных
  # Интерфейс между Ruby и SQLite3 довольно прямолинеен. Класс SQLite::Database позволяет открыть файл базы
  # и выполнять SQL-запросы к ней. Ниже приведен просто пример кода:
  require "sqlite3"

  # Открыть новую базу данных
  db = SQLite::Database.new("library.db")

  # Создать таблицу для хранения книг
  db.execute "create table books (
    title varchar(1024), author varchar(256) );"

  # Вставить в таблицу записи
  {
    "Robert Zubrin" => "The Case for Mars",
  }.each do |author, title|
    db.execute "insert into books values (?, ?)", [title, author]
  end

  # Читать записи из таблицы с использованием блока
  db.execute("select title, author from books") do |row|
    p row
  end

  # Закрыть базу
  db.close

  # Выводится:
  # ["The Case for Mars", "Robert Zubrin"]
  # ["Democracy in America", "Alexis de Tocqueville"]
  # Если блок не задан, то метод execute возвращает массив массивов, и все строки можно обойти:
  rs = db.execute("select title, author from books")
  rs.each {|row| p row}           # Тот же результат,что и выше

  # Методы библиотеки могут возбуждать различные исключения. Все они являются подклассами класса SQLite::Exception,
  # так что легко перехватываются поодиночке или целой группой.
  # Хотя библиотека sqlite в достаточной мере функциональна, сама база SQLite не полностью реализует стандарт SQL92.
  # Если вам нужна полная база данных SQL, обратитесь к PostgreSQL или MySQL.
  
  # Подключение к внешним базам данных.
  # Подключение к базе данных MySQL
  # Метод класса Mysql2::Client.new принимает несколько строковых параметров, по умолчанию равных nil, 
  # и возвращает объект-клиент. Наиболее полезны параметры host,username,password,port и database.
  # Метод клиента query используется для взаимодействия с базой данных:
  require 'mysql2'

  client = Mysql2::Client.new(
    :host => "localhost",
    :username => "root"
  )

  # Создать базу данных
  client.query("CREATE DATABASE mailing_list")

  # Воспользоваться базой данных
  client.query("USE mailing_list")

  # Если база данных уже существует, команду USE можно опустить, указав параметр database:
  # Создать таблицу для хранения имен и почтовых адресов
  client.query("CREATE TABLE members (
    name varchar(1024), email varchar(1024))")

  # Вставить строки с описанием двух подписчиков на список рассылки
  client.query <<-SQL
         INSERT INTO members VALUES
         ('John Doe', 'jdoe@rubynewbie.com'),
         ('Fred Smith', 'smithf@rubyexpert.com')
  SQL
  # Вставляя данные, не забывайте экранировать значения! Злонамеренный пользователь может отправить специально
  # сконструированные данные, которые уничтожат базу данных или даже предоставят ему права администратора.
  # Чтобы предотвратить это, перед вставкой передавайте данные методу escape.
  escaped = ["Bod Howard", "bofh@laundry.gov.uk"].map do |value|
    "'#{client.escape(value)}'"
  end
  client.query("INSERT INTO members VALUES (#{escaped.join(",")})")

  # Если в ответ на запрос был отправлен результат, то возвращается экземпляр класса Mysql2::Result, к 
  # которому подмешан модуль Enumerable. Поэтому строки результата можно перебирать методом each или
  # любым другим, входящим в состав Enumerable.
  # Запросить данные и вернуть каждую строку в виде хэша
  client.query("SELECT * from members").each do |member|
    puts "Name: #{member["name"]}, Email: #{member["email"]}"
  end
  # Выводится:
  # Name: John Doe, Email: jdoe@rubynewbie.com
  # Name: Fred Smith, Email: smithf@rubyexpert.com
  # Name: Bob Howard, Email: bofh@laundry.gov.uk

  # Поддерживаются все типы данных MySQL, а строки, числа, время и другие типы автоматически преобразуются
  # в объекты соответствующих классов Ruby.
  # Объект Result отдает каждую строку результата в виде хэша. Ключи хэша по умолчанию являются строками,
  # но можно сделать их символами, если передать методу query параметр :symbolize_keys => true.
  # Из полезных методов Result назовем еще count (количество возвращенных строк) и fields (массив имен столбцов результата)
  # Метод each может также отдавать строки результата в виде массива значений, если передать ему параметр :as=>:array.
  # Запросить данные и вернуть каждую строку в виде массива
  result = client.query("SELECT * FROM members")
  puts "#{result.count} records"
  puts result.fields.join(" - ")
  result.each(:as => :array) {|m| puts m.join(" - ")}
  # Выводится:
  # 3 records
  # name - email
  # John Doe - jdoe@rubynewbie.com
  # Fred Smith - smithf@rubyexpert.com
  # Bob Howard - bofh@laundry.gov.uk

  # Имена существующих баз данных можно получить, воспользовавшись специфичной для MySQL командой SHOW DATABASES:
  client.query("SHOW DATABASES").to_a(:as => :array).flatten
  # ["information_schema", "mailing_list", "mysql",
  #  "perfomance_schema", "test"]

  # Наконец, для закрытия соединения с базой служит метод close:
  # Закрыть соединение с базой данных
  client.close
  
  # Подключение к базе данных PostgreSQL
  # Gem-пакет pg представляет интерфейс для подключения к базе данных PostgreSQL, он устанавливается
  # командой gem install или bundle install после того, как PostgreSQL и Ruby уже установлены.
  # Как и для других адаптеров баз данных, нужно загрузить модуль, установить соединение с базой данных
  # и начать работу с таблицами. Для установления соединения в классе PG имеется метод connect.
  # У объекта соединения есть методо exec (синоним query) для отправки SQL-запросов базе данных:
  require 'pg'

  # Создать базу данных
  PG.connect.exec("CREATE DATABASE pets")

  # Открыть соединение с созданной базой данных
  conn = PG.connect(dbname: "pets")
  # Отметим, что в отличие от MySQL, для смены базы данных необходимо создать новое соедниение, а не выполнить запрос.
  # Отправка запроса с помощью библиотеки pg делается так же, как и в любой другой библиотеке SQL:
  # Создать таблицу и вставить в нее данные
  conn.exec("CREATE TABLE pets (name varchar(255),
    species varchar(255), birthday date)")
  conn.exec <<-SQL
    INSERT INTO pets VALUES
      ('Spooky', 'cat', '2008-10-03'),
      ('Spot', 'dog', '2004-06-10')
  SQL
  # Экранирование вставляемых значений существенно упрощается благодаря методу exec_params, который
  # умеет экранировать переданные ему значения:
  # Экранировать данные при вставке
  require 'date'
  conn.exec_params("INSERT INTO pets VALUES ($1, $2, $3)",
    ['Maru', 'cat', Date.today.to_s])
  # Но, в отличие от gem-пакета mysql2 пакет pg не преобразует результаты запроса в объекты соответствующих
  # классов Ruby. Все результаты возвращаются в виде строк, при необходимости их нужно будет 
  # преобразовать самостоятельно. Ниже мы вызываем метод Date.parse для каждого присутствующего в результате поля даты:
  # Запросить данные:
  res = conn.query("SELECT * FROM pets")
  puts "There are #{res.count} pets."
  res.each do |pet|
    name = pet["name"]
    age = (Date.today - Date.parse(pet["birthday"]))/365
    species = pet["species"]
    puts "#{name} is a #{age.floor}-year-old #{species}."
  end

  # Выводится:
  # There are 3 pets.
  # Spooky is a 5-year-old cat.
  # Spot is a 10-year-old dog.
  # Maru is a 0-year-old cat.

  # Метод each всегда отдает строки результата в виде хэшей, но экземпляр класса PG::Result, возвращенный
  # после выполнения запроса, может предоставлять значения в виде массива строк, каждая из которых представляет
  # собой массив. Из других полезных методов отметим еще count (количество возвращенных строк) и fields
  # (массив имен столбцов результата).
  
  # Объектно-реляцонные отображения (ORM)
  # В gem-пакете activerecord это делается с помощью отдельного класса Ruby для каждой таблицы базы данных.
  # Он умеет выполнять некоторые запросы без привлечения SQL, представляет каждую строку в виде экземпляра
  # класса и позволяет добавлять предметную логику. Имена классов соответствуют именам таблиц, и все они
  # наследуют классу ActiveRecord::Base. Для всех классов нужно только одно соединение с базой данных.
  # Вот небольшой пример, демонстрирующий весь механизм в действии:
  require 'active_record'

  class Pet < ActiveRecord::Base
  end

  ActiveRecord::Base.establish_connection(
    :adapter => "postgresql", :database => "pets")
  
  snoopy = Pet.new(name: "Snoopy", species: "dog")
  snoopy.birthday = Date.new(1950, 10, 4)
  snoopy.save

  p Pet.all.map {|pet| pet.birthday.to_s}

  # Как видите, класс умеет выводить имена таблиц, представляет акцессоры атрибутов, основанные на именах
  # столбцов, и выполняет запрос в объектно-ориентированном стиле. Кроме того, он предлагает один и тот же
  # API, включающий преобразования типов данных, для любой базы данных SQL.
  
  # Подключение к хранилищу данных Redis
  # Для подключения к серверу Rediss применяется gem-пакет redis. Если сервер работает на той же машине, что и клиент, 
  # никакие параметры вообще не нужны:
  require 'redis'
  r = Redis.new
  # Один из полезных типовв хранимых данных - множество. Redis умеет быстро вычислять разность, пересечение и объединение
  # нескольких множеств. При этом результат либо возвращается, либо сохраняется с другим ключом.
  # Сохранить клички домашних животных в множестве
  r.sadd("pets", "spooky")
  # Полуxить элементы множества
  r.smembers("pets")         # ["spooky"]
  
  # Тип хэш позволяет читать несколько полей и записывать их с общим ключом, по одному или все сразу.
  # Использовать кличку домашнего животного как ключ хэша для других его аттрибутов
  r.hset("spooky", "species", "cat")
  r.hset("spooky", "birthday", "2008-10-03")

  # Получить одно значение из хэша
  Get a single hash value
  r.hget("spooky")            # {"species"=>"cat", "birthday"=>"2008-10-03"}

  # Получить весь хэш
  r.hgetall("spooky")         # {"species"=>"cat", "birthday"=>"2008-10-03"}

  # Отсортированное множество ассоциирует с каждым значением числовую оценку и предоставляет специальные команды для 
  # увеличения и уменьшения этих оценок, а также для извлечения значения в порядке следования оценок.
  # Использовать отсортированное множестов для хранения домашних животных, отсортированных по весу
  r.zadd("pet_weights", 6, "spooky")
  r.zadd("pet_weights", 12, "spot")
  r.zadd("pet_weights", 2, "maru")

  # Выбрать первое значение из множества, отсортированного в порядке убывания
  r.zrevrange("pet_weights", 0, 0)    # => ["spot"]
  # С помощью различных предоставляемых Redis типов данных возможны и другие сложные и оптимизированные операции.
  ------------------------------------------------------------------------------
  # ООП и динамические механизмы в Ruby
  # Рутинные объектно-ориентированныые задачи
  # Применение нескольких конструкторов
  # В следующем примере приведен исскуственный пример класса для представления прямоугольника, у которого есть две длины
  # сторон и три значения цвета. Мы создали дополнительные методы класса, предполагающие определенные умолчания для
  # каждого параметра. (Например, квадрат - это прямоугольник, у которого все стороны равны.)
  class ColoredRectangle

    def initialize(r, g, b, s1, s2)
      @r, @g, @b, @s1, @s2 = r, g, b, s1, s2
    end

    def self.white_rect(s1, s2)
      new(0xff, 0xff, 0xff, s1, s2)
    end

    def self.gray_rect(s1, s2)
      new(0xff, 0xff, 0xff, s1, s2)
    end

    def self.colored_square(r, g, b, s)
      new(r, g, b , s, s)
    end

    def self.red_square(s)
      new(0xff, 0, 0, s, s)
    end

    def inspect
      "#@r #@g #@b #@s1 #@s2"
    end
  end

  a = ColoredRectangle.new(0xff, 0xff, 0xff, 20, 30)
  b = ColoredRectangle.white_rect(15, 25)
  c = ColoredRectangle.red_square(40)
  # Таким образом, можно определить любое число методов, создающих объекты по различным спецификациям. 

  # Создание аттрибутов экземпляра
  # Имени атрибута экземпляра в Ruby всегда предшествует знак @. Это обычная переменная в стом смысле, что она начинает
  # существовать после первого присваивания.
  # В ОО-языках часто создаются методы для доступа к аттрибутам, чтобы обеспечить сокрытие данных. Мы хотим контролировать
  # доступ к "внутренностям" объекта извне. Обычно для этой цели применяются методы чтения и установки (getter и setter),
  # хотя в Ruby эта терминология не используется. Они просто читают (get) или устанавливают (set) значение аттрибута.
  # Можно, конечно, запрограммировать такие функции "вручную", как показано ниже:
  class Person
    
    def name 
      @name
    end

    def name=(x)
      @name = x
    end

    def age
      @age
    end

    # ...

  end
  
  # Но Ruby предоставляет более короткий способ. Метод attr принимает в качестве параметра символ и создает
  # соответствующий атрибут. Кроме того, он создает одноименный метод чтения, а если необязательный второй
  # параметр равен true, то и метод установки.
  class Person
    attr :name, true  # Создаются @name, name, name=
    attr :age         # Создаются @age, age
  end
  # Методы attr_reader, attr_writer и attr_accessor принимают в качестве параметров произвольное число
  # символов. Первый создает только "методы чтения" (для получения значения атрибута); второй - только
  # "методы установки", а третий - то и другое. Пример:
  class SomeClass
    attr_reader :a1, :a2         # Создаются @a1, a1, @a2, a2
    attr_writer :b1, :b2         # Создаются @b1, b1=, @b2, b2=
    attr_accessor :c1, :c2       # Создаются @c1, c1, c1=, @c2, c2, c2=
    # ...

    def initialize
      @a1 = 237
      @a2 = nil
    end

  end
  # Напомним, что для выполнения присваивания атрибуту необходимо указывать вызывающий объект, а внутри метода
  # нужно в качестве такого объекта указывать self.
  def update_ones(a1, b1, c1)
    self.a1 = a1
    self.b1 = b1
    self.c1 = c1
  end
  # Если не указать self, то Ruby просто создаст внутри метода локальную переменную с указанным именем,
  # а это совсем не то, что нам нужно.
  # Существует специальный метод, позволяющий узнать, определена ли уже переменная экземпляра:
  obj = SomeClass.new
  obj.instance_variable_defined?(:b2)       # true
  obj.instance_variable_defined?(:d2)       # true
  # Повинуясь нашему желанию использовать eval только в случае острой необходимости, Ruby предоставляет
  # также методы для чтения или присваивания значения переменной, имя которой задано в виде строки:
  class MyClass
    attr_reader :alpha, :beta

    def initialize(a, b, g)
      @alpha, @beta, @gamma = a, b, g
    end
  end

  x = MyClass.new(10, 11, 12)

  x.instance_variable_set("@alpha", 234)
  p x.alpha                                  # 234

  x.instance_variable_set("@gamma", 345)      # 345
  v = x.instance_variable_get("@gamma")       # 345
  # Прежде всего обратите внимание на знак @ в имени переменной: если его опустить, произойдет ошибка.
  # Если это кажется вам интуитивно неочевидным, вспомните, что методы типа attr_accessor на самом деле
  # принимают в качестве имени метода символ, поэтому-то в них и можно опускать знак @.
  
  # Более сложные конструкторы
  # Чтобы справиться со сложностью, можно передать методу initialize блок. Тогда инициализация выполняется
  # в процессе вычисления этого блока.
  class PersonalComputer
    attr_accessor :manufacturer,
                  :model, :processor, :clock,
                  :ram, :disk, :monitor,
                  :colors, :vres, :hres, :next

    def initialize(&block)
      instance_eval &block
    end

      # Прочие методы...
  end
  
  desktop = PersonalComputer.new do
    self.manufacturer = "Acme"
    self.model = "THX-1138"
    self.processor = "986"
    self.clock = 9.6                 # ГГц
    self.ram = 16                    # Гб
    self.disk = 20                   # ТБ
    self.monitor = 25                # дюймы
    self.colors = 16777216
    self.vres = 1280
    self.hres = 1600
    self.net = "ТЗ"
  end

  p desktop
  # Отметим, что мы пользуемся акцессорами для присваивания атрибутам значений. Кроме того, в теле блока
  # можно было бы сделать все что угодно. Например, вычислить одни поля по значениям других.
  # А если мы не хотим, чтобы у объекта были акцессоры для всех атрибутов? В таком случае можно было бы
  # воспользоваться методом instance_eval и сделать методы установки защищенными - protected. Этоо предотвратит
  # "случайное" присваивание значения атрибуту извне объекта.
  class library
    attr_reader :shelves

    def initialize(&block)
      instance_eval(&block)
    end

    protected

      attr_writer :shelves
  end

  branch = Library.new do
    self.shelves = 10
  end

  branch.shelves = 20
  # NoMethodError: protected method 'shelves=' called
  branch.shelves       # 10
  # Но даже при использовании instance_eval необходимо явно вызывать метод установки от имени self.
  # Метод установки всегда вызывается от имени явно указанного объекта, чтобы отличить его от присваивания локальной переменной.
  
  # Создание атрибутов и методов уровня класса
  # В следующем далеко не полном фрагменте предполагается, что мы создаем класс для проигрывания звуковых
  # файлов. Метод play естественно реализовать как метод экземпляра, ведь можно создать много объектов, каждый
  # из которых будет проигрывать свой файл. Но, у метода detect_hardware контекст более широкий;
  # в зависимости от реализации может оказаться, что создавать какие-либо объекты вообще не имеет смысла, 
  # если этот метод возвращает ошибку. Следовательно, его контекст - вся среда воспроизведения звука, а не
  # конкретный звуково файл.
  class SoundPlayer
    MAX_SAMPLE = 192

    def self.detect_hardware
      # ...
    end

    def play
      # ...
    end

  end
  # Есть еще один способ объявить этот метод класса. В следующем фрагменте делается практически то же самое:
  class SoundPlayer
    MAX_SAMPLE = 192

    def play
      # ...
    end

  end

  def SoundPlayer.detect_hardware
    # ...
  end
  # Единственная разница касается использования объявленных в классе констант. Если метод класса объявлен
  # вне объявления самого класса, то эти константы оказываются вне области видимости. Например, в первом
  # фрагменте метод detect_hardware может напрямую обращаться к константе MAX_SAMPLE, а во втором придется
  # пользоваться нотацией SoundPlayer::MAX_SAMPLE.
  # Не удивительно, что, помимо методов класса, есть еще и переменные класса. Их имена начинаются с 
  # двух знаков @, а областью видимости является весь класс, а не конкретный его экземпляр.
  # Традиционный пример использования переменных класса - подсчет числа экземпляров этого класса.
  # Но они могут применяться всегда, когда информация имеет смысл в контексте класса в целом, а не отдельного объекта
  class Metal
    @@current_temp = 70

    attr_accessor :atomic_number

    def self.current_temp(x)
      @@current_temp = x 
    end

    def delf.current_temp
      @@current_temp
    end

    def liquid?
      @@current_temp >= @melting
    end

    def initialize(atnum, melt)
      @atomic_number = atnum
      @melting = melt
    end

  end

  aluminum = Metal.new(13, 1236)
  copper = Metal.new(29, 1982)
  gold = Metal.new(79, 1948)

  Metal.current_temp = 1600

  puts aluminum.liquid?            # true
  puts copper.liquid?              # false
  puts gold.liquid?                # false

  Metal.current_temp = 2100

  puts aluminum.liquid?            # true
  puts copper.liquid?              # true
  puts gold.liquid?                # true

  # О переменных экземпляра класса
  # Данные класса и экземпляра
  class MyClass

    SOME_CONST = "alpha"           # Константа уровня класса

    @@var = "beta"                 # Переменная класса
    @var = "gamma"                 # Переменная экземпляра класса

    def initialize
      @var = "delta"               # Переменная экземпляра
    end

    def mymethod
      puts SOME_CONST              # (константа класса)
      puts @@var                   # (переменная класса)
      puts @var                    # (переменная экземпляра)
    end

    def self.classmeth1
      puts SOME_CONST              # (константа класса)
      puts @@var                   # (переменная класса)
      puts @@var                   # (переменная класса)
      puts @var                    # (переменная экземпляра класса)
    end

  end

  def MyClass.classmeth2
    puts MyClass::SOME_CONST       # (константа класса)
    # puts @@var                   # ошибка: вне области видимости
    puts @var                      # (переменная экземпляра класса)
  end
  myobj = MyClass.new
  MyClass.classmeth1               # alpha, beta, gamma
  MyClass.classmeth2               # alpha, gamma
  myobj.mymethod                   # alpha, beta, delta
  # Следует еще сказать, что метод класса можно сделать закрытым, воспользовавшись методом private_class_method.
  # Это аналог метода private на уровне экземпляра.

  # Наследование суперклассу
  # Можно унаследовать класс, воспользовавшись символом <:
  class Boojum < Shark
    # ...
  end
  # Это объявление говорит, что класс Boojum является подклассом класса Snark или - что то же самое - 
  # класс Snark является суперклассом класса Boojum. Всем известно, что каждый буюм является снарком, но
  # не каждый снарк - буюм.
  # Ясно, что цель наследования - расширить или специализировать функциональность. Мы хотим из общего нечто более специфическое.
  
  # Рассмотрим несколько более реалистичный пример. Пусть есть класс Person(человек), а мы хотим создать
  # производный от него класс Student(студент).
  # Определим класс Person следующим образом:
  class Person
  
    attr_accessor :name, :age, :sex

    def initialize(name, age, sex)
      @name, @age, @sex = name, age, sex
    end

    # ...

  end

  # А класс Student - так:
  class Student < Person

    attr_accessor :idnum, :hours

    def initialize(name, age, sex, idnum, hours)
      super(name, age, sex)
      @idnum = idnum
      @hours = hours
    end
    # ...

  end

  # Создать два объекта
  a = Person.new("Dave Bowman", 37, "m")
  b = Student.new("Franklin Poole", 36, "m", "000-13-5031", 24)
  # Посмотрим внимательно, что здесь сделано. Что за super, вызываемый из метода initialize класса Student?
  # Это просто вызов соответствующего метода родительского класса. А раз так, то ему передается три 
  # параметра (хотя наш собственный метод initialize принимает пять).
  # Если говорить об истинном смысле наследования, то оно, безусловно, описывает отношение "является".
  # Студент является человеком, как и следовало ожидать.
  # Если вызывается некий метод от имени объекта класса Student, то будем вызван метод, определенный в этом
  # классе, если он существует. А если нет, вызывается метод суперкласса и так далее вверх по иерархии наследования.
  # Мы говорим "и так далее", потому что у каждого класса (кроме BasicObject) есть суперкласс. Попутно отметим
  # что BasicObject - "чистая доска" в мире объектов, у него даже меньше методов, чем у Object.
  # А если мы хотим вызвать метод суперкласса, но, не из соответствующего метода подкласса?
  # Можно создать сначала в подклассе синоним:
  class Student                     # повторное открытие класса
    # Предполагается, что в классе Person есть метод say_hello...
    alias :say_hi :say_hello

    def say_hello
      puts "Привет."
    end

    def format_greeting
      # Поприветствовать так, как принято в суперклассе.
      say_hi
    end
  
  # Опрос класса объекта
  # Часто возникает вопрос: "Что за объект? Как он соотносится с данным классом?" Есть много способов получить тот или иной ответ.
  # Во-первых, метод экземпляра class всегда возвращает класс объекта. Применявшийся ранее синоним type объявлен устаревшим.
  s = "Hello"
  n = 237
  sc = s.class         # String
  nc = n.class         # Integer
  
# Не думайте, будто методы class или type возвращают строку, представляющую имя класса. На самом деле возвращается
# экземпляр класса Class! При желании мы могли бы вызвать метод класса, определяемый в этом типе, как если бы
# это был метод экземпляра класса Class (каковым он в дейтствительности и является)
s2 = "some string"
var = s2.class             # String
my_str = var.new("Hi...")  # Новая строка
# Можн сравнить такую переменную с константным именем класса и выяснить, равны ли они; можно даже использовать
# переменную в роли суперкласса и определить на ее основе подкласс! 
# Иногда нужно сравнить объект с классом, чтобы понять принадлежит ли данный объект указанному классу. 
# Для этого служит метод instance_of?, например:
puts (5.instance_of? Integer)        # true
puts ("XYZZY".instance_of? Integer)  # false
puts ("PLUGH".instance_of? String)   # true

# А если нужно принять во внимание еще и отношение наследования? К вашим услугам метод kind_of? (похожий на instance_of?)
# У него есть синоним is_a?, что вполне естественно, ибо мы описываем классическое отношение "является"
n = 9876543210
flag1 = n.instance_of? Bignum     # true
flag2 = n.kind_of? Bignum         # true
flag3 = n.is_a? Bignum            # true
flag4 = n.is_a? Numeric           # true
flag5 = n.is_a? Object            # true
flag6 = n.is_a? String            # false
flag7 = n.is_a? Array             # false
# Ясно, что метод kind_of? или is_a? более общий, чем instance_of?. Например, всякая собака - млекопитающее,
# но, не всякое млекопитающее - собака.

# Для новичков в Ruby приготовлен сюрприз. Любой модуль, подмешиваемый в класс, становится субъектом отношения
# "является" для экземпляров этого класса. Например, в класс Array подмешан модуль Enumerable;
# это означает, что всякий массив является перечисляемым объектом.
x = [1, 2, 3]
flag8 = x.kind_of? Enumerable     # true
flag9 = x.is_a? Enumerable        # true
# Для сравнения двух классов можно пользоваться также операторами сравнения. Интуитивно очевидно, что 
# оператор "меньше" обозначает наследование суперклассу.
flag1 = Integer < Numeric         # true
flag2 = Integer < Object          # true
flag3 = Object == Array            # false
flag4 = IO >= File                # true
flag5 = Float < Integer           # nil
# В любом классе обычно определен оператор "тройного равенства" ===. Выражение class === instance истинно,
# если экземпляр instance принадлежит классу Class. Этот оператор еще называют оператором ветвящегося равенства, 
# потому что он неявно используется в предложении case.
# Упомянем еще метод respond_to. Он используется, когда нам безразлично, какому классу принадлежит объект,
# но мы хотим знать, реализует ли он конкретный метод. Методу respond_to передается символ и необязательный
# флаг, который говорит, нужно ли включать в рассмотрение также и закрытые методы.
# Искать открытые методы
if wumpus.respond_to?(:bite)
  puts "У него есть зубы!"
else
  puts "Давай-ка подразним его."
end

# Необязательный второй параметр позволяет просматривать и закрытые методы.
if woozle.respond_to?(:bite, true)
  puts "Вузлы кусаются!"
else
  puts "Ага это не кусающийся вузл."
end

# Иногда нужно знать, является ли данный класс непосредственным родителем объекта или класса. Ответ на этот
# вопрос дает метод superclass класса Class.
array_parent = Array.superclass           # Object
fn_parent = 237.class.superclass          # Integer
obj_parent = Object.superclass            # BasicObject
basic_parent = BasicObject.superclass     # nil
# У любого класса кроме BasicObject, есть суперкласс.

# Проверка объектов на равенство, примеры:
flag1 = (1 == 1.0)          # true
flag2 = (1.eql?(1.0))       # false - метод eql? никогда не считает объекты разных типов равными.

# Любой объект реализует еще два метода сравнения. Метод === применяется для сравнения проверяемого значения
# в предложении case с каждым селектором: selector===target. Хотя правило на первый взгляд кажется сложным
# на практике оно делает предложения case в Ruby интуитивно очевидными. Например, можно выполнить ветвление
# по классу объекта:
case an_object
  when String
    puts "Это строка"
  when Numeric
    puts "Это число"
  else
    puts "Это что-то совсем другое"
end
# Эта конструкция работает, потому что в классе Module реализован метод ===, проверяющий, что параметр принадлежит
# тому же классу, что и вызывающий объект (или одному из его предков). Поэтому, если an_object - это строка
# "cat", то выражение String === an_object окажется истинным, и буте выбрана первая ветвь в предложении case.

# Управление доступом к методам
# В Ruby объект определяется, прежде всего, своим интерфейсом: теми методами, которые он раскрывает внешнему миру.
# Но при написании класса часто возникает необходимость во вспомогательных методах, вызываать которые извне
# класса опасно. Тут-то и приходит на помощь метод private класса Module.
# Использовать его можно двумя способами. Если в теле класса или модуля вы вызовите private без параметров, 
# то все последующие методы будут закрытыми в данном классе или модуле. Если же вы передадите ему список имен
# методов (в виде символов), то эти и только эти методы станут закрытыми. Ниже показаны оба варианта:
class Bank
  def open_safe
    # ...
  end

  def close_safe
    # ...
  end

  private :open_safe, :close_safe

  def make_withdrawal (amount)
    if access_allowed
      open_safe
      get_cash(amount)
      close_safe
    end
  end

  # остальные методы закрытые

  private

  def get_cash
    # ...
  end

  def access_allowed
    # ...
  end
end

# Поскольку методы из семейства attr просто определяют методы, то метод private определяет и видимость 
# атрибутов тоже. Реализация метода private может показаться странной, но на самом деле она весьма хитроумна.
# К закрытым методам нельзя обратиться, указав вызывающий объект, они вызываются только от имени неявно
# подразумеваемого объекта self. То есть вызвать закрытый метод из другого объекта не удастся, просто 
# не существует способа указать объект, от имени которого этт метод вызывается. Заодно то означает, что
# закрытые методы доступны подклассаам того класса, в котором определены, но опять же в рамках одного объекта.
# Модификатор доступа protected налагает меньше ограничений. Защищенные методы доступны только экземплярам того
# класса, в котором определены, и его подклассов. Выше мы видели, что модификатор protected позволяет вызывать
# методы установки от имени self (при наличии модификатора private это невозможно).
# К защищенным методам можно обращаться из других объектов (при условии, что вызывающиий и вызываемый объекты
# принадлежат одному классу). Обыно защищенные методы применяются для определения методов доступа, чтобы два
# объекта одного типа могли взаимодействавать. В следующем примере объекты класса Person можно сравнивать 
# по возрасту, но сам возраст недоступен вне класса Person. Закрытый атрибут pay_scale можно прочитать
# внутри класса, но извне класса он недоступен даже другим объектам того же класса:
class Person
  attr_reader :name, :age, :pay_scale
  protected   :age
  private     :pay_scale

  def initialize(name, age, pay_scale)
    @name, @age, @pay_scale = name, age, pay_scale
  end

  def <=>(other)
    age <=> other.age   # allowed by protected
  end

  def same_rank?(other)
    pay_scale == other.pay_scale  # not allowed by private
  end

  def rank 
    case pay_scale
    when 1..3
      "lower"
    when 4..6
      "middle"
    when 7..9
      "high"
    end
  end
end

# И чтобы довершить картину, модификатор public делает метод открытым. Неудивительно.
# И последнее: методы, определенные вне любого класса и модуля (то есть на верхнем уровне программы), по
# умолчанию закрыты. Поскольку они определены в классе Object, то видимы глобально, но обращаться к ним
# с указанием вызывающег метода нельзя.

# Копирование объектов.
# Встроенные методы Object#clone и #dup порождают копию вызывающего объекта. Различаются они объемом 
# копируемого текста. Метод #dup копирует только само содержимое объекта, тогда как clone сохраняет
# и такие вещи, как синглетные классы, ассоциированные с объектом.
s1 = "cat"

def s1.upcase
  "CaT"
end

s1_dup = s1.dup
s1_clone = s1.clone
s1                     #=> "cat"
s1_dup.upcase          #=> "CAT"  (синглетный метод не копируется)
s1_clone.upcase        #=> "CaT"  (синглетный метод используется)
# И dup и clone выполняют поверхностное копирование, то есть копируют лишь содержимое самого вызывающего объекта.
# Если вызывающий объект содержит ссылки на другие объекты, то последние не копируются, копия будет ссылаться
# на те же самые объекты. Проиллюстрируем это на примере. Объект arr2[2] не оказывает влияния на arr1.
# Но исходный массив и его копия содержат ссылку на один и тот же объект String, поэтому изменение строки
# через arr2 приведет к такому же изменению значения, на котрое ссылается arr1.
arr = [ 1, "flipper", 3]
arr2 = arr1.dup

arr2[2] = 99
arr2[1][2] = 'a'

arr1                        # [1, "flapper", 3]
arr2                        # [1, "flapper", 99]

# Метод initialize_copy
# При копировании объекта методом dup или clone конструктор не вызывается. Копируется вся информация о состоянии.
# Но, что делать если вам такое поведение не нужно? Рассмотрим пример:
class Document
  attr_accessor :title, :text
  attr_reader   :timestamp

  def initialize(title, text)
    @title, @text = title, text
    @timestamp = Time.now
  end
end

doc1 = Document.new("Random Stuff", File.read("somefile"))
sleep 300                         # Немного подождем...
doc2 = doc1.clone

doc1.timestamp == doc2.timestamp  # true
# Оп... временные штампы одинаковые!
# При создании объекта Document с ним ассоциируются временная метка. При копировании объекта копируется и его 
# временная метка. А как быть, если мы хотим запомнить время, когда было выполнено копирование?
# Для этого нужно определелить метод initialize_copy. Он вызывается как раз при копированиии объекта.
# Этот метод аналогичен initialize и позволяет полностью контролировать состояние объекта.
class Document                    # Повторно открываем определение класса
  def initialize_copy(other)
    @timestamp = Time.now
  end
end

doc3 = Document.new("More Stuff", File.read("otherfile"))
sleep 300                         # Немного подождем...
doc4 = doc3.clone

doc3.timestamp == doc4.timestamp  # false
# Теперь временные метки правильны.
# Отметим, что метод initialize_copy вызывается после того, как вся информация скопирована.
# Поэтому мы и опустили строку:
@title, @text = other.title, other.text
# Кстати, если метод initialize_copy пуст, то поведение будет такое же, как если бы он не был определен вовсе.

# Метод allocate
# Редко, но бывает, что нужно создать объект, не вызывая его конструктор (в обход метода initialize).
# Например, можеть статься, что состояние объекта полностью определяется методами доступа к нему, тогда 
# не нужно вызывать метода new (который вызывает метод initialize), разве что вы сами захотите это сделать.
# Представьте, что для инициализации состояния объекта вы собираете данные по частям, тогда начать следует
# с "пустого" объекта, а не получить все данные заранее, а потом вызвать конструктор.
# Метод allocate упрощает решение этой задачи. Он возвращает "чистый", еще не инициализированный объект класса.
class Person
  attr_accessor :name, :age, :phone

  def initialize(n, a, p)
    @name, @age, @phone = n, a, p 
  end
end

p1 = Person.new("John Smith", 29, "555-1234")

p2 = Person.allocate

p p1.age      # 29
p p2.age      # nil

# Модули
# Модуль это не класс, у него не может быть экземпляровв, а к методу экземпляра нельзя обратиться, не указав
# вызывающий объект. Но, оказывается, модуль может иметь методы экземпляра. Они становятся частью класса, 
# который включил модуль директивой include.
module myMod 

  def meth1
    puts "Это метод 1"
  end

end

class MyClass

  include myMod
  # ...
end

x = MyClass.new
x.meth1                   # Это метод 1
# Здесь модуль MyMod подмешан к классу MyClass, а метод экземпляра meth1 унаследован. Вы видели также,
# как директива include употребляется на верхнем уровне программы; в таком случае модуль подмешивается
# к классу Object.
# А что происходит с методами модуля, если таковые определены? Если вы думаете, что они становятся методами
# класса, то ошибаетесь. Методы модуля не подмешиваются.
# Но если такое поведение желательно, то его можно реализовать с помощью нехитрого трюка. Существует метод
# included, который можно переопределить. Он вызывается с параметром - "целевым" классом или модулем 
# (в который включается данный модуль). 
module MyMod

  def self.included(klass)
    def klass.module method 
      puts "Module (class) method"
    end
  end

  def method_1
    puts "Method 1"
  end

end

class MyClass

  include MyMod

  def self.class_method 
    puts "Class method"
  end

  def method_2
    puts "Method 2"
  end

end

x = MyClass.new 
                             # Выводится:
MyClass.class_method         # Class method
x.method_1                   # Method 1
MyClass.module_method        # Module (class) method
x.method_2                   # Method 2
# Этот пример заслуживает детального рассмотрения. Во-первых, надо понимать, что метод included вызывается
# в ходе выполнения include. При желании мы могли бы реализовать свой метод include, определив append_features,
# но такое решение встречается гораздо реже (да и вряд ли вообще желательно).
# Отметим также, что внутри тела included имеется еще одно определение метода. Выглядит оно необычно, но, 
# работает, поскольку вложенное определение порождает синглетный метод (уровня класса или модуля).
# Попытка определить таким образом метод экземпляра привела бы к ошибке Nested method error (Ошибка при определении
# вложенного метода).
# Модуль мог бы захотеть узнать, кто был инициатором примеси. Для этого тоже мможно воспользоваться методом
# included, потому что класс-инициатор передается ему в качестве параметра.
# Можно также подмешивать метды экземпляра модуля как методы класса с помощью метода include или extend.
module MyMod 
  
  def meth3
    puts "Метод экземпляра модуля meth3"
    puts "может стать методом класса."
  end

end

class MyClass

  class << self       # Здесь self - это MyClass
    include MyMod
  end

end

MyClass.meth3

# Выводится:
# Метод экземпляра модуля meth3
# может стать методом класса.
# Здесь полезен метод extend. Тогда можно записать так:
class MyClass
  extend MyMod
end
# Также можно подмешивать модуль к объекту, а не классу (например, метод extend).
# Важно понимать одну вещь. В вашем классе можно определить методы, которые будут вызываться из примеси.
# Это эффектный прием, знакомыц тем, кто пользовался интерфейсами в Java.
# Классический пример (с которым мы уже сталкивались ранее), - подмешивание модуля Comparable и определение
# метода <=>. Поскольку подмешанные методы могут вызывать метод сравнения, то мы получаем операторы 
# <,> <= и т.д.
# Другой пример подмешивание модуля Enumerable и определение метода <=> и итератора each. Тем самым мы
# получаем ряд полезных методов: collect, sort, min, max и select.

# Можно также определять и собственные модули, ведущие себя подобным образом. Возможности ограничены только
# вашим воображением.
# Иногда объект имеет нужный вид в нужное время, а иногда хочется преобразовать его во что-то другое или
# сделать вид, что он является чем-то, чем на самом деле не является. Всем известный пример - метод to_s
# Каждый объект можно тем или иным способом представить в виде строки. Но не каждый объект может успешно
# "прикинуться" строкой. Именно в этом и состоит различие между методами to_s и to_str. 
# Рассмотрим этот вопрос подробнее. При использованиии метода puts или интерполяции в строку
# (в контексте #{...}) ожидается, что в качестве параметра будет передан объект String.
# Если это не так, объект просят преобразовать себя в String, посылая ему сообщение to_s.
# Именно здесь вы можете определить, как объект следует отобразить, просто реализуйте метод to_s
# в своем классе так, чтобы он возвращал подходящую строку.
class Pet

  def initialize(name)
    @name = name
  end

  # ...

  def to_s
    "Pet: #@name"
  end

end
# Другие методы (например, оператор конкатенации строк +) не так требовательны, они ожидают получить нечто
# достаточно близкое к объекту String. В этом случае Матц решил, что интерпретатор не будет вызывать метод
# to_s для преобразования не-строковых аргументов, поскольку это могло бы привести к большому числу ошибок.
# Вместо этого вызывается более строгий метод to_str. Из всех встроенных классов только String и Exception
# реализуют to_str, и лишь String, Regexp и Marshal вызывают его. Увидев сообщение TypeError:Failed to convert
# xyz into String, можно смело сказать, что интерпретатор пытался вызвать to_str и потерпел неудачу.
# Можно реализовать метод to_str и самостоятельно, например, чтобы строку можно было конкатенировать с числом:
class Numeric

  def to_str
    to_s
  end

end

label = "Число " + 9       # "Число 9"
# Аналогично дело обстоит и для массивов. Для преобразования объекта в массив служит метод to_a, 
# а метод to_ary вызывается, когда ожидается массив и ничего другого, например, в случае множественного
# присваивания. Пусть есть предложение такого вида:
a, b, c = X
# Если x - массив трех элементов, оно будет работать ожидаемым образом. Но, если это не массив, интерпретатор
# попытается вызвать метод to_ary для преобразования в массив. В принципе, это может быть даже синглетный
# метод (принадлежащий конкретному объекту). На само преобразование не налагается никаких ограничений, 
# ниже приведен (нереалистичный) пример, когда строка преобразуется в массив строк:
class String
  
  def to_ary
    return self.split("")
  end

end

str = "UFO"
a, b, c = str              # ["U", "F", "O"]
# Метод inspect реализует другое соглашение. Отладчики, утилиты типа irb и метод отладочной печати p
# вызывают inspect, чтобы преобразовать объект к виду, пригодному для вывода на печать. Если вы хотите,
# чтобы во время отладки объект раскрывал свое внутренее устройство, то переопределите inspect.

# Классы, содержащие только данные (Struct)
# Иногда нужно просто сгруппировать взаимосвязанные данные. Поначалу кажется, что для этого достаточно 
# воспользоваться массивом или хэшем. Но такой подход хрупок - становится трудно изменить внутреннюю структуру
# класса или добавить методы акцессоры. Можно было бы попытаться решить проблему, создав такой класс:
class Address

  attr_accessor :street, :city, :Stardate

  def initialize(street, city, state)
    @street, @city, @state = street, city, state
  end

end

books = Address.new("411 Elm St", "Dallas", "TX")

# Такое решение годится, но каждый раз прибегать к нему утомительно, к тому же здесь слишком много повторов
# Тут то и приходит на помощь встроенный класс Struct. Если вспомогательные методы типа attr_accessor определяют
# методы доступа к атрибутам, то Struct определяет целый классс, который может содержать только атрибуты.
# Такие классы называют структурными шаблонами.
Address = Struct.new("Address", :street, :city, :state)
books = Address.new("411 Elm St", "Dallas", "TX")
# Зачем передавать первым параметрам конструктора имя создаваемой структуры и присваивать результат
# в константе (в данном случае Address)?
# При вызове Struct.new для создания нового структурного шаблона на самом деле создается новый класс внутри
# самого класса Struct. Этому классу присваивается имя, переданное первым  параметром, а остальные параметры
# становятся именами атрибутов. При желании к вновь созданному классу можно было бы полуить доступ,
# указав пространство имен Struct:
Struct.new("Address", :street, :city, :state)
books = Struct::Address.new("411 Elm St", "Dallas", "TX")
# Если первый аргумент Struct.new - символ, то все аргументы считаются именами атрибутов, и класс в 
# пространстве имен Struct не создается.
# При создании класса Struct можно определить дополнительные методы, передав конструктору Struct.new блок.
# Этот блок будет вычисляться тк, будто он является телом класса - практически так же, как в определении любого класса
# Создав стуктурный шаблон, мы вызываем его метод new для создания новых экземпляров данной конкретной 
# структуры. Необязательно присваивать значения всем атрибутам в конструкторе. Опущенные атрибуты получат 
# значение nil. После того как структура создана, к ее атрибутам можно обращаться с помощью обычного синтаксиса
# или указывая их имена в скобках в качестве индекса, как будто структура - это объект класса Hash.
# Кстати, не рекомендуется создавать структуру с именем Tms, так как уже есть предопределенный класс Struct::Tms.

# Замораживание объектов
# Иногда необходимо воспрепятствовать изменению объекта. Это позволяет сделать метод freeze (определенный в класс
# Object). По существу, он превращает объект в константу.
# Попытка модифицировать замороженный объект приводит к исключению TypeError.
str = "Это тест."
str.freeze

begin
  str << " Не волнуйтесь."               # Попытка модифицировать
rescue => err 
  puts "#{err.class} #{err}"
end

arr = [1, 2, 3]
arr.freeze

begin
  arr << 4
rescue => err
  puts "#{err.class} #{err}"
end

# Выводится:
# TypeError: can't modify frozen string
# TypeError can't modify frozen array

# Замораживание строк считается особым случаем. Интерпретатор создает единственный объект замороженной 
# строки и возвращает его при каждом обращении к этой строке. Это снижает потребление памяти, если, например,
# некая строка возвращается из метода, который вызывается многократно:
str1 = "Woozle".freeze
str2 = "Woozle".freeze

str1.object_id == str2.object_id    # true

# Но хотя замораживание и предотвращает модификацию, имейте в виду, что метод freeze применяется к ссылке
# на объект, а не к переменной! Это означает, что любая операция, приводящая к созданию нового объекта,
# завершится успешно. Иногда это противоречит интуиции. В примере ниже мы ожидаем, что операция += 
# не выполнится, но все работает нормально. Дело в том, что присваивание - не вызов метода. 
# Это операция воздействует на переменные, а не объекты, поэтому новый объект создается беспрепятственно.
# Старый объект по-прежнему заморожен, но переменная ссылается уже на него.
str = "counter-"
str.freeze 
str += "intuitive"                   # "counter-intuitive"

arr = [8, 6, 7]
arr.freeze 
arr += [5, 3, 0, 9]                  # [8, 6, 7, 5, 3, 0, 9]
# Почему так происходит? Предложение a += x семантически эквивалентно a = a + x.
# При вычислении выражения a + x создается новый объект, который затем присваивается переменной a!
# Все составные операторы присваивания работают подобным образом, равно как и другие методы. Всегда задавайте
# себе вопрос: "Что я делаю - создаю новый объект или модифицирую существующий?" И тогда поведение
# freeze не станет для вас сюрпризом.
# Существует метод frozen?, который сообщает, заморожен ли данный объект.
hash = {1 => 1, 2 => 4, 3 => 9}
hash.freeze
arr = hash.to_a 
puts hash.frozen?    # true
puts arr.frozen?     # false
hash2 = hash
puts hash2.frozen?   # true
# Как видно (на примере hash2), замораживается именно объект, а не переменная.

# Использование метода tap в цепочке методов
# Методу tap передается блок, из которого имеется доступ к значению выражения, вычисляемого другими операциями.
# (По-английски, слово "tap" означает прослушивание телефона или отвод от трубы).
# Например, так можно распечатывать промежуточные значения в ходе их обработки, потому что блоку
# передается объект, от имени которого метод tap вызван:
a = [1, 5, 1, 4, 2, 3, 4, 3, 2, 5, 2, 1]
p a.sort.uniq.tap{|x| p x}.map { |x| x**2 + 2*x + 7 }
# [1, 2, 3, 4, 5]
# [10, 15, 22, 31, 42]
# Наличие такого доступа полезно само по себе, но истинная мощь tap проявляется, когда нужно изменить 
# объект внутри блока. Это позволяет программе модифицировать объект и при этом вернуть исходный объект,
# а не результат последней операции:
def feed(woozle)
  woozle.tap do |w|
    w.stomach << Steak.new
  end
end
# Не будь здесь tap, метод feed вернул бы объект stomach (желудок), в котором теперь находится steak (стейк).
# А так возвращается покормленный (и, надо полагать, довольный) вузл.
# Эта техника особенно полезна в методах класса, которые конструируют объект, вызывают какие-то методы 
# нового объекта, а затем возвращают его. Удобна она и для реализации методов, которые планируют сцеплять.

# Посылка объекту явного сообщения
# Пусть, например, имеется массив объектов, который нужно отсортировать, причем в качестве ключей сортировки
# хотелось бы использовать разные поля. Не проблема, можно просто написать специализированные блоки для 
# сортировки. Но хотелось бы найти более элегантное решение, позволяющее обойти одной процедурой, способной
# выполнить сортировку по любому указанному ключу. Ниже такое решение приведено:
class Person
  attr_reader :name, :age, :height

  def initialize(name, age, height)
    @name, @age, @height = name, age, height
  end

  def inspect
    "#@name #@age #@height"
  end
end

class Array
  
  def map_by(sym)
    self.map { |x| send(sym) }
  end
end

people = {}
people << Person.new("Hansel", 35, 69)
people << Person.new("Gretel", 32, 64)
people << Person.new("Ted", 36, 68)
people << Person.new("Alice", 33, 63)

p1 = people.map_by(:name)                 # Hansel, Gretel, Ted, Alice
p2 = people.map_by(:age)                  # 35, 32, 36, 33
p3 = people.map_by(:height)               # 69, 64, 68, 63
# Этот код на самом деле излишен, потому то можно получить тот же результат, просто вызвав метод
# map(&:name), но мы хотели проиллюстрировать использование метода send.
# Отметим еще, что синоним __send__ делает в точности то же самое. Такое странное имя объясняется, конечно,
# опасением, что имя send уже может быть задействовано (случайно или намеренно) для определенного пользователем метода.
# С методом send связана одна проблема: он позволяет обойти модель закрытости в Ruby (в том смысле, что
# закрытый метод мможно вызвать косвенно, отправив объекту строку или символ методом send). Это не ошибка
# проектирования, а сознательное решение, но если вы чувствуете себя увереннее, "защитившись" от такого
# непреднамеренного использования, то можете обратиться к методу public_send.

# Специализация отдельного объекта
# Создание синглетного метода
# В следующем примере мы видим два объекта, оба строки. Для второго мы добавляем метод upcase, который
# переопределяет существующий метод с таким же именем.
a = "hello"
b = "goodbye"

def b.upcase              # создать синглетный метод
  gsub(/(.) (.)/) { $1.upcase = $2}
end

puts a.upcase             # HELLO
puts b.upcase             # GoOdBye
# Добавление синглетного метода к объекту порождает синглетный класс для данного объекта, если он еще 
# не был создан ранее. Родителем синглетного класса является исходный класс объекта. (Можно считать, что
# это анонимный подкласс исходного класса.) Если вы хотите добавить к объекту несколько методов, то можете
# создать синглетный класс явно:
b = "goodbye"

class << B
  
  def upcase              # создать синглетный класс
    gsub(/(.) (.)/) { $1.upcase + $2 }
  end

  def upcase!
    gsub!(/(.) (.)/) { $1.upcase + $2 }
  end

end

puts b.upcase             # GoOdBye
puts b                    # goodbye
b.upcase!
puts b                    # GoOdBye
# У более "примитивных" объектов (например, Fixnum) не может быть добавленных синглетных методов. Связано
# это с тем что такие объекты хранятся как непосредственные значения, а не как ссылки. Впрочем, реализация
# подобной функциональности планируется в будущих версиях Ruby.
# Если вам приходилось разбираться в коде библиотек, то наверняка вы сталкивались с идиоматическим использованием
# синглетных классов. В определении класса иногда встречается такой код:
class SomeClass
  
  # Какой-то код...

  class << self
    # еще какой-то код...
  end

  # ... продолжение.

end
# В теле определения класса слово self обозначает сам определяемый класс, поэтому создание наследуещего
# ему синглета модифицирует класс этого класса.
# Можно сказать, что методы экземпляра синглетного класса извне выглядят как методы самого класса.
class TheClass
  class << self
    def hello
      puts "hi"
    end
  end
end

# вызвать метод класса
TheClass.hello                 # hi
# Еще одно распространенное применение данной техники - определение на уровне класса вспомогательных функций,
# к которым можно обращаться из других мест внутри определения класса. Например, мы хотим определить несколько
# функций доступа, которые преобразуют результат своей работы в строку. Можно, конечно, написать отдельно
# код каждой такой функции. Но, есть более элегантное решение - определить функцию уровня класса 
# accessor_string, которая сгенерирует необходимые нам функции. Пример ниже:
class MyClass

  class << self

    def accessor_string(*names)
      names.each do |name|
        class_eval <<-EOF
          def #{name}
            @#{name}.to_s
          end
        EOF
      end
    end
  end

  def initialize
    @a = [1, 2, 3]
    @b = Time.now
  end

  accessor_string :a, :begin
end

o = MyClass.new
puts o.a                         # 123
puts o.b                         # 2014-07-26 00:45:12 -0700

# Метод extend подмешивает к объекту модуль. Методы экземпляра, определенные в модуле, становятся методами
# экземпляра объекта. 
module Quantifier
  def two?
    2 == self.select { |x| yield x }.size
  end

  def four?
    4 == self.select { |x| yield x }.size
  end

end

list = [1, 2, 3, 4, 5]
list.extend(Quantifier)

flag1 = list.two? { |x| x > 3 }                    # => true
flag2 = list.two? { |x| x >= 3 }                   # => false
flag3 = list.four? { |x| x <= 4 }                  # => true
flag4 = list.four? { |x| x % 2 == 0 }              # => false
# В этом примере к массиву list подмешаны методы two? и four?.

# Создание параметрических классов
# Предположим, что нужно создать несколько классов, отличающихся только начальными значениями переменных
# уровня класса. Напомним, что переменная класса обычно инициализируется в самом определении класса.
class Terran

  @@home_planet = "Earth"

  def Terran.home_planet
    @@home_planet
  end

  def Terran.home_planet=(x)
    @@home_planet = x 
  end

  # ...

end
# Все замечательно, но что если нам нужно определить несколько подобных классов. Новичок подумает:
# "Так я просто определю суперкласс"
class IntelligentLife          # Неправильный способ решения задачи!

  @@home_planet = nil

  def IntelligentLife.home_planet
    @@home_planet
  end

  def IntelligentLife.home_planet=(x)
    @@home_planet = x 
  end

  # ...
end

class Terran < IntelligentLife
  @@home_planet = "Earth"
  # ...
end

class Martian < IntelligentLife
  @@home_planet = "Mars"
end
# Но это работать не будет. Вызов Terran.home_planet напечатает не "Earth" а "Mars"!
# Почему так? Дело в том, что переменные класса на деле не вполне переменные класса; они принадлежат не одному
# классу, а всей иерархии наследования. Переменная класса не копируется из родительского класса, а разделяется
# с родителем (и, стало быть, со всеми братьями).
# Можно было бы вынести определение переменной класса в базовый класс, но тогда перестали бы работать определенные
# нами методы класса! Можно было бы исправить и это, перенеся определения в дочерние классы, но это губит
# первоначальную идею, ведь таким образом объявляются отдельные классы без какой бы то ни было "параметризации"

# Мы предлагаем другое решение. Отложим вычисление переменной класса до моментна выполнения, воспользовавшись 
# методом class_eval.
class IntelligentLife

  def IntelligentLife.home_planet
    class_eval("@@home_planet")
  end

  def IntelligentLife.home_planet=(x)
    class_eval("@@home_planet = #{x}")
  end

  # ...
end

class Terran < IntelligentLife
  @@home_planet = "Earth"
  # ...
end

class Martian < IntelligentLife
  @@home_planet = "Mars"
  # ...
end

puts Terran.home_planet                            # Earth
puts Martian.home_planet                           # Mars
# Не стоит и говорить, что механизм наследования здесь по-прежнему работает. Все методы и переменные
# экземпляра, определенные в классе IntelligentLife, наследуются классами Terran и Martian.
# В следующем решении предложено, наверное, наилучшее решение. В нем используются только переменные экземпляра,
# а от переменных класса мы вообще отказались:
class IntelligentLife
  class << self
    attr_accessor :home_planet
  end

  # ...
end

class Terran < IntelligentLife
  self.home_planet = "Earth"
  # ...
end

class Martian < IntelligentLife
  self.home_planet = "Mars"
end

puts Terran.home_planet                    # Earth
puts Martian.home_planet                   # Mars
# Здесь мы открываем синглетный класс и определяем метод доступа home_planet.
# В двух подклассах определяются собственные методы доступа и устанавливается переменная. Теперь методы
# доступа работают строго в своих классах. 
# В качестве небольшого усовершенствования добавим еще вызов метода private в синглетный класс:
private :home_planet=
# Сделав метод установки закрытым, мы запретили изменять значение вне иерархии данного класса.
# Как всегда, private реализует "рекомендательную" защиту, которая легко обходится. Но объявление метода
# закрытым по крайней мере говорит, что мы не хотели, чтобы метод вызывался вне определенного контекста.

# Хранение кода в виде объектов Proc
# В этом разделе рассмотрим объкты Proc и лямбда-выражения.
# Встроенный класс Proc позволяет обернуть блок в объект. Объекты Proc, как и блоки, являютя замыканиями,
# то есть запоминают контекст, в котором были определены. Метод proc - просто сокращенная запись Proc.new
local = 12
myproc = Proc.new { |a| puts "Параметр равен is #{a}, local равно #{local}" }
myproc.call(99)                    # Параметр равен 99б local равно 12
# Кроме того, Ruby автоматически создает объект Proc, когда метод, последний параметр которого помечен
# амперсандом, вызывается с блоком в качестве параметра:
def take_block(x, &block)
  puts block.class
  x.times { |i| block[i, i*i] }
end

take_block(3) { |n, s| puts "#{n} в квадрате равно #{s}" }
# В этом примере демонстрируется также применение квадратных скобок как синонима метода call. 
# Вот что выводится в результате выполнения:
Proc
0 в квадрате равно 0
1 в квадрате равно 1
2 в квадрате равно 4
# Объект Proc можно передавать методу, который ожидает блок, предварив имя знаком &:
myproc = proc { |n| print n, "... " }
(1..3).each(&myproc)                        # 1... 2... 3...

# Возможность передавать объект Proc методу, безусловно, полезна, но если внутри Proc встретится предложение
# return, то произойдет выход из всего метода. Специальная разновидность объектов Proc - лямбда-выражение, 
# или просто лямбда - позволяет вернуть управление только из блока:
def greet(&block)
  block.call
  "Всем доброе утро."
end

philippe_proc = Proc.new { return "Слишком рано, Филипп!" }
philippe_lambda = lambda { return "Слишком рано, Филипп!" }
p greet(philippe_proc)          # Слишком рано, Филипп!
p greet(philippe_lambda)        # Всем доброе утро.
# Для создания лямбда-выражений применяется не только ключевое слово lambda, но и нотация ->.
# Но, помните, что при использовании оператора -> аргументы блока указываются во внешних фигурных скобках:
non_stabby_lambda = lambda { |king| greet(king) }
stabby_lambda = -> (king) { stab(king) }

# Хранение кода в виде объектов Method
# Ruby позволяет также превратить метод в объект непосредственно с помощью метода Object#method, который
# создает объект класса Method как замыкание, связанное с тем объектом, из которого он был создан.
str = "cat"
meth = str.method(:length)

a = meth.call                            # 3 (длина "cat")
str << "erpillar"
b = meth.call                            # 11 (длина "caterpillar")

str = "dog"
c = meth.call                            # 11 (длина "caterpillar")
# Обратите внимание на последний вызов call! Переменная str теперь ссылается на новый объект ("dog"),
# но meth по-прежнему связан со старым объектом.
# Метод public_method работает аналогично, но, как следует из названия, ищет только открытые методы 
# объекта-получателя.
# Чтобы получить метод, который можно будет использовать для любого экземпляра конкретного класса, 
# можно применить метод Module#instance_method для создания объектов UnboundMethod. Прежде чем вызывать
# объект UnboundMethod, нужно связать его с каким то объектом. Результатом операции связывания является
# объект Method, который можно вызывать как обычно:
umeth = String.instance_method(:length)

m1 = umeth.bind("cat")
m1.call                                # 3

m2 = umeth.bind("caterpillar")
m2.call                                # 11
# Связывание метода с неподходящим классом приведет к ошибке, но возможность связывания с другими объектами
# делает объект UnboundMethod интуитивно немного более понятным, чем Method.

# Использование символов в качестве блоков
# Если параметру предшествует знак амперсанда, то Ruby считает его блоком. Как мы уже видели, можно создать
# объект Proc, присвоить его переменной, а затем передать в качестве блока методу, принимающему блок.
# Однако в разделе 11.2.1 было сказано, что можно вызывать методы, принимающие блок, но только при условии
# что им передается символ, которому предшествует знак амперсанда. Как такое возможно? Ответ кроется в методе to_proc.
# Неочевидный побочный эффект передачи блока в качестве аргумента состоит в том, то если аргумент не является
# объектом Proc, то Ruby сделает попытку преобразовать его в такой, вызвав метод to_proc.
# Изобретательные программисты поняли, что этим можно воспользоваться, чтобы упростить обращения к методу map,
# и начали определять метод to_proc в классе Symbol. Реализация выглядит так:
class Symbol 
  def to_proc
    Proc.new { |obj| obj.send(self) }
  end
end

# Что позволяет вызывать map следующим образом:
%w[A B C].map(&:chr)    # [65, 66, 67]
# Этот прием оказался настолько популярным, что был включен в сам язык Ruby, и теперь им можно воспользоваться везде.

# Как работает включение модулей?
# Когда модуль включается в класс, Ruby на самом деле создает прокси-класс,являющийся непосредственным 
# родителем данного класса. Возможно, вам это покажется интуитивно очевидным, возможно, нет. Все методы
# включаемого модуля "маскируются" методами, определенными в классе.
module MyMod
  def meth
    "из модуля"
  end
end

class ParentClass
  def meth
    "из родителя"
  end
end

class ChildClass < ParentClass
  include MyMod
  def meth
    "из потомка"
  end
end

x = ChildClass.new
p x.meth                        # из потомка
# Выгляидит это как настоящее наследование: все, что потомок переопределил, становится действующим определением
# вне зависимости от того, вызывается ли include до или после переопределения.
# Вот похожий пример, в котором метод потомка вызывает super, а не просто возвращает строку.
# Модуль MyMod и класс ParentClass не изменились
class ChildClass < ParentClass
  include MyMod
  def meth
    "из потомка: super = " + super
  end
end

x = ChildClass.new
p x.meth                         # из потомка: super = из модуля
# Отсюда видно, что модуль действительно является новым родителем класса.
# А что если мы точно также вызовем super из модуля?
module MyMod
  def meth
    "из модуля: super = " + super
  end
end
# ParentClass не изменился

class ChildClass < ParentClass
  include MyMod
  def meth
    "из потомка: super= " + super
  end
end

x = ChildClass.new
p x.meth                       # из потомка: super = из модуля: super = из родителя

# У модулей припасен еще один козырь в рукаве - метод prepend. Он позволяет вставить метод модуля выше
# метода включающего класса:
# MyMod и ParentClass не изменились.

class ChildClass < ParentClass
  prepend MyMod
  def meth
    "из потомка: super " = super
  end
end

x = ChildClass.new
p x.meth    # из модуля: super из потомка: super из родителя
# Эта особенность Ruby позволяет модулям изменять поведение методов, даже если метод класса-потомка 
# не вызывает super.
# Вне зависимости от того, как включен модуль - методом include или prepend, - метод meth, определенный
# в модуле MyMod, может вызвать super только потому, что в суперклассе (точнее, хотя бы в одном из его предков)
# действительно есть метод meth. А что произошло бы, вызови мы этот метод при других обстоятельствах?
module MyMod
  def meth
    "из модуля: super = " + super
  end
end

class Foo
  include MyMod
end

x = Foo.new
x.meth
# При выполении этого кода мы получили бы ошибку NoMetodError (или обращение к методу method_missing,
# если бы таковой существовал).

# Опознание параметров, заданных по умолчанию
# Однажды Ян Макдоналд задал в списке рассылки вопрос: "Можно ли узнать, был ли параметр задан вызывающей
# программой или взято значение по умолчанию?" Интересный вопрос. 
# Было предложено по меньшей мере три решения. Самое удачное и простое нашел Нобу Накада. Вот оно:
def meth(a, b=(flag=true; 345))
  puts "b равно #{b}, а flag равно #{flag.inspect}"
end

meth(123)                             # b равно 345, а flag равно true
meth(123,345)                         # b равно 345, а flag равно nil
meth(123,456)                         # b равно 456, а flag равно nil
# Как видим, этот подход работает, даже если вызывающая программа явно указала значение параметра, совпадающее
# с подразумеваемым по умолчанию. Трюк становится очевидным, едва вы его увидите: выражение в скобках
# устанавливает локальную переменную flag в true, а затем возвращает значение по умолчанию 345.
# Это дань могуществу Ruby.

# Делегирование или перенаправление
# В Ruby есть две библиотеки, которые предлагают решение задачи о делегировании или перенаправлении 
# вызовов методов другому объекту. Они называются delegate и forwardable; мы рассмотрим обе.
# Библиотека delegate предлагает три способа решения задачи.
# Класс SimpleDelegator полезен, когда объект, которому делегируется управление (делегат), может изменяться
# на протяжении времени жизни делегирующего объекта. Чтобы выбрать объект-делегат, используется метод __setobj__.
# Метод верхнего уровня DelegateClass принимает в качестве параметра класс, которому делегируется управление.
# Затем он создает новый класс, которому мы можем унаследовать. Вот пример создания класса Queue, 
# который делегирует объекту Array:
require 'delegate'
class MyQueue < DelegateClass(Array)

  def initialize(arg=[])
    super(arg)
  end

  alias_method :enqueue, :push
  alias_method :dequeue, :shift
end

mq = MyQueue.new

mq.enqueue(123)
mq.enqueue(234)

p mq.dequeue              # 123
p mq.dequeue              # 234

# Можно также унаследовать класс Delegator и реализовать метод __getobj__;
# именно таким образом реализован класс SimpleDelegator. При этом мы получаем больший контроль над делегированием.
# Но если вам необходим больший контроль, то, вероятно, вы все равно осуществляете делегирование на уровне
# отдельных методов, а не класса в целом. Тогда лучше воспользоваться библиотекой forwardable.
# Вернемся к примеру очереди:
require 'forwardable'

class MyQueue
  extend Forwardable

  def initialize(obj=[])
    @queue = obj              # делегировать этому объекту
  end

  def_delegator :@queue, :push, :enqueue
  def_delegator :@queue, :shift, :dequeue

  def delegators :@queue, :clear, :empty?, :length, :size, :<<

  # Прочий код...
end

# Как видно из этого примера, метод def_delegator ассоциирует вызов метода (скажем, enqueue)
# с объектом-делегатом @queue и одним из методов этого объекта (push). Иными словами, когда мы вызываем метод
# enqueue для объекта MyQueue, производится делегирование методу push объекта @queue (который обычно является массивом)
# Обратите внимание, мы пишем :@queue, а не :queue. Объясняется это тем как написан класс Forwardable; 
# можно было сделать по-другому.
# Иногда нужно делегировать методы одного объекта одноименным методам другого объекта. Метод def_delegators
# позволяет задать произвольное число таких методов. Например, в примере выше показано, то вызов метода
# length объекта MyQueue приводит к вызову метода length объекта @queue.
# В отличие от первого примера, остальные методы делегирующим объектом просто не поддерживаются. Иногда
# это хорошо. Ведь не хотите же вы вызывать метод [] или []= для очереди; если вы так поступаете, то очередь
# перестает быть очередью.
# Отметим еще, что показанный выше код позволяет вызывающей программе передавать объект конструктору (для
# использования в качестве объекта-делегата). В полном соответствии с духом динамической типизации это 
# означает, что я могу выбирать вид объекта, которому делегировать управление, коль скоро он поддерживает
# те методы, которые вызываются в программе.
# Например, все приведенные ниже вызовы допустимы. (В последних двух предполагается, что предварительно было 
# выполнено предложение require 'thread'.)
q1 = MyQueue.new                                # используется любой массив
q2 = MyQueue.new(my_array)                      # используется конкретный массив
q3 = MyQueue.new(Queue.new)                     # используется Queue (thread.rb)
q4 = MyQueue.new(SizedQueue.new)                # используется SizedQueue (thread.rb)
# Так, объекты q3 и q4 волшебным образом становятся потокобезопасными, поскольку делегируют управление 
# потокобезопасному объекту (если, конечно, какой-нибудь не показанный здесь код не нарушит эту гарантию).
# Существует также класс SingleForwardable, который воздействует на один экземпляр, а не на класс в целом.
# Это полезно, если вы хотите, что какой-то конкретный объект делегировал управление другому объекту, 
# а все остальные объекты того же класса этого не делали.
# И последний вариант - ручное делегирование. В Ruby очень просто обернуть один объект другим, и это
# позволяет реализовать очередь следующим образом:
class MyQueue
  def initialize(obj=[])
    @queue = obj                                 # делегировать этому объекту
  end

  def enqueue(arg)
    @queue.push(arg)
  end

  def dequeue(arg)
    @queue.shift(arg)
  end

  %i[clear empty? length size <<].each do |name|
    define_method(name) {|*args| @queue.send(name, *args) }
  end

  # Прочий код...
end
# Как видите, в некоторых случаях использование для делегирования библиотеки не дает заметного выигрыша 
# по сравнению с написанием собственного простого кода.

# Автоматическое определение методов чтения и установки на уровне класса
# Мы уже рассматривали методы attr_reader, attr_accessor, которые немного упрощают определение методов 
# чтения и установки атрибутов экземпляра. А как же быть с атрибутами уровня класса?
# В Ruby нет аналогичных средств для их автоматического создания. Но можно написать нечто подобное
# самостоятельно. Нужно лишь открыть синглетный класс и воспользоваться в нем семейством методов attr.
# Получающиеся переменные экземпляра для синглетного класса станут переменными экземпляра класса. Часто
# это оказывается лучше, чем переменные класса, поскольку они принадлежат данному и только данному классу,
# не наспространяясь вверх и вниз по иерархии наследования.
class MyClass

  @alpha = 123                             # Инициализировать @alpha

  class << self
    attr_reader :alpha                     # MyClass.alpha()
    attr_writer :beta                      # MyClass.beta()
    attr_accessor :gamma                   # MyClass.gamma() и MyClass.gamma=()
  end

  def MyClass.look
    puts "#@alpha, #@beta, #@gamma"
  end

  #...
end

puts MyClass.alpha                         # 123
MyClass.beta = 456 
MyClass.gamma = 789
puts MyClass.gamma                         # 789

MyClass.look                               # 123, 456, 789
# Как правило, класс без переменных экземпляра бесполезен. Но здесь их для краткости опустили.

# Динамическая интерпретация кода
# Глобальная функция eval компилирует и исполняет строку, содержащую код на Ruby. Это очень мощный (и вместе
# с тем опасный) механизм, поскольку позволяет строить подлежащий исполнению код во время работы программы.
# Например, в следующем фрагменте считываются строки вида "имя = выражение", затем каждое выражение вычисляется,
# а результат сохраняется в хэше, индексированном именем переменной.
parameters = {}

ARGF.each do |line|
  name, expr = line.split(/\s*=\s*/, 2)
  parameters[name] = eval expr
end
# Пусть на вход подаются следующие строки:
a = 1
b = 2 + 3
c = 'date'
# Тогда в результате мы получим такой хэш: {"a"=>1, "b"=>5, "c"=>"Sat Jul 26 00:51:48 PDT 2014\n"}
# На этом примере демонстрируется также опасность вычисления с помощью eval строк, содержимое которых
# вы не контролируете; злонамеренный пользователь может подсунуть строку d = `rm *` и стереть все сделанное вами за день.

# Можно инкапсулировать текущую привязку в объекте с помощью метода Kernel#binding. Тогда вы сможете
# передать привязку в виде второго параметра методу eval, установив контекст исполнения для 
# интерпретируемого кода.
def some_method
  a = 'local variable'
  return binding
end

the_binding = some_method
eval "a", the_binding      # "local variable"
# Интересно, что информация о наличии блока, ассоциированного с методом, сохраняется как часть 
# привязки, поэтому возможны такие трюки:
def some_method
  return binding
end

the_binding = some_method { puts "hello" }
eval "yield", the_binding                          # hello

# Метод const_get
# Метод const_get получает значение константы с заданным именем из модуля или класса, которому она принадлежит
str = "PI"
Math.const_get(str)                                # Значение равно Math::PI
# Это способ избежать обращения к методу eval, которое иногда считается неэлегантным. Такой подход дешевле
# с точки зрения потребления ресурсов и безопаснее. Есть и другие аналогичные методы: instance_variable_set,
# instance_variable_get и define_method.
# Метод const_get действительно работает быстрее, чем eval. В неформальных тестах - на 350% быстрее, хотя у вас
# может получиться другой результат. Но так ли это важно? Ведь в тестовой программе на 10 миллионов итераций
# цикла все равно ушло менее 30 секунд.
# Истинная ценность метода const_get в том, что его проще читать, он более специфичен и лучше самодокументировван.
# Даже если бы он был всего лишь синонимом eval, все равно это стало бы большим шагом вперед.

# Получение класса по имени
# Следующий вопрос мы встречали многократно. Пусть дана строка, содержащая имя класса, как можно создать
# экземпляр этого класса?
# Имена классов в Ruby - константы в "глобальном" пространстве имен, то есть члены класса Object.
# Это означает, то правильный способ - воспользоваться методом const_get, который мы только что рассмотрели.
classname = "Array"
klass = Object.const_get(classname)
x = klass.new(4, 1)                    # [1, 1, 1, 1]
# Если константа определена внутри пространства имен, то достаточно задать строку, в которой это пространство
# имен отделено от имени константы двумя двоеточиями (как если бы вы писали прямо на Ruby):
class Alpha
  class beta
    class Gamma 
      FOOBAR = 237 
    end
  end
end

str = "Alpha::Beta::Gamma::FOOBAR"
val = Object.const_get(str)                 # 237

# Метод define_method
# Помимо ключевого слова def, единственный нормальный способ добавить метод в класс или объект - воспользоваться
# методом define_method, причем он позволяет сделать это во время выполнения.
# Конечно, в Ruby практически все происходит во время выполнения. Если окружить определение метода обращениями
# к puts, как в примере ниже, вы это сами увидите.
class MyClass
  puts "до"

  def meth
    #...
  end

  puts "после"
end

# Но внутри тела метода или в другом аналогичном месте нельзя заново открыть класс (если только это не
# синглетный класс). В таком случае в прежних версиях Ruby приходилось прибегать к помощи eval, теперь
# же у нас есть метод define_method. Он принимает символ (имя метода) и блок (тело метода).
# Отметим, однако, что define_method - закрытый метод. Это означает, что обращение к нему из определения
# класса или метода работает нормально:
class MyClass
  define_method(:body_method) { puts "Тело класса." }

  def self.new_method(name, &block)
    define_method(name, &block)
  end
end

MyClass.new_method(:class_method) { puts "Метод класса."}

x = MyClass.new
x.body_method                                # Печатается "Тело класса."
x.class_method                               # Печатается "Метод класса."

# Можно даже создать метод экземпляра, который будет динамически определять другие методы экземпляра:
class MyClass
  def new_method(name, &block)
    self.class.send(:define_method, name, &block)
  end
end

x = MyClass.new
x.new_method(:instance_method) { puts "Метод экземпляра." }
x.mymeth                                      # Печатается "Метод экземпляра."
# Здесь метод экземпляра тоже определен динамически. Изменился только способ реализации метода new_method
# Обратите внимание на трюк с send, позволивший нам обойти закрытость метода define_method. 
# Он работает, потому что метод send позволяет вызывать закрытые методы. (Некоторые сочтут это "дыркой";
# как бы то ни было, пользоваться этим механизмом следует с осторожностью.)
# По поводу метода define_method нужно сделать еще одно замечание. Он принимает блок, а в Ruby блок - замыкание.
# Это означает, что в отличие от обычного определения метода, мы запоминаем контекст, в котором метод был 
# определен. Следующий пример практически бесполезен, но этот момент иллюстрирует:
class MyClass
  def self.new_method(name, &block)
    define_method(name, &block)
  end
end

a, b = 3,79

MyClass.new_method(:compute) { a*b }
x = MyClass.new 
puts x.compute                        # 237

a,b = 23,24
puts x.compute                        # 552
# Смысл здесь в том, что новый метод может обращаться к переменным в исходной области видимости блока, 
# хотя сама эта область более не существует и никаким другим способом не доступна. Иногда это бывает полезно,
# особенно в случае метапрограммирования или при разработке графических интерфейсов, когда нужно определить
# методы обратного вызова, реагирущие на события.
# Отметим, что замыкание имеет доступ только к переменным с такими же именами. Изредка из-за этого могут
# возникать сложности. Ниже мы воспользовались методом define_method, чтобы предоставить доступ к переменной
# класса (вообще-то это следует делать не так, но для иллюстрации подойдет):
class SomeClass
  @@var = 999

  define_method(:peek) { @@var }
end

x = SomeClass.new 
p x.peek                              # 999
# А теперь попробуем проделать этот трюк с переменной экземпляра класса:
class SomeClass
  @var = 999

  define_method(:peek) { @var }
end

x = SomeClass.new
p x.peek                              # печатается nil
# Мы ожидали, что будет напечатано 999, а получили nil. С другой стороны, такой код работает правильно:
class SomeClass
  @var = 999

  x = @var
  
  define_method(:peek) { x }
end

x = SomeClass.new
p x.peek                              # 999
# Так что же происходит? Да, замыкание действительно запоминает переменные в текущем контексте. Но хотя
# замыкание и знает о переменных в своей облисти видимости, контекст метода - это контекст объекта, а не
# самого класса.
# Поскольку имя @eval в контексте экземпляра относится к переменной экземпляра объекта, а не класса, то
# переменная экземпляра класса оказывается скрыта переменной экземпляра объекта, хотя последняя никогда
# не использовалась и технически не существует.
# При работе с отдельными объектами удобной альтернативой открытию синглетного класса и определению в нем 
# метода является метод define_singleton_method.
# Работает он аналогично define_method.
# Хотя определять методы во время выполнения с помощью eval разрешено, лучше этого не делать. Во всех 
# таких случаях может и должен использоваться метод define_method. Некоторые тонкости, вроде рассмотренной 
# выще, не должны вас останавливать.

# Получение списка определенных сущностей
# API отражения в Ruby позволяет опрашивать классы и объекты во время выполения. Рассмотрим методы, 
# имеющиеся для этой цели в Module, Class и Object.
# В модуле Module есть метод constants, который возвращает массив всех констант, определенных в системе
# (включая имена классов и модулей). Метод nesting возвзращает массив всех вложенных модулей, видимых в
# данной точке программы.
# Метод экземпляра Module#ancestors возвращает массив всех предков указанного класса или модуля.
list = Array.ancestors              # [Array, Enumerable, Object, Kernel, BasicObject]
# Метод constants возвращает список всех констант, доступных в данном модуле. Включаются также его предки.
list = Math.constants  # [:DomainError, :PI, :E]
# Метод class_variables возвращает список всех переменных класса в данном классе и его суперклассах. 
# Метод included_modules возвращает список модулей, включенных в класс.
class Parent 
  @@var1 = nil
end
class Child < Parent
  @@var2 = nil
end

list1 = Parent.class_variables           # ["@@var1"]
list2 = Array.included_modules           # [Enumerable, Kernel]

# Методы instance_methods и public_instance_methods класса Class - синонимы; они возвращают список открытых
# методов экземпляра, определенных в классе. Методы private_instance_methods и protected_instance_mehtods
# ведут себя аналогично. Любой из них принимает необязательный флаг, по умолчанию равный true, если его 
# значение равно false, то суперклассы не учитываются, так что список получается меньше.
n1 = Array.instance_methods.size                      # 174
n2 = Array.public_instance_methods.size               # 174
n3 = Array.public_instance_methods(false).size        # 90
n4 = Array.private_instance_methods.size              # 84
n5 = Array.protected_instance_mehtods.size            # 0
# В классе Object есть аналогичные методы, применяющиеся к экземплярам. Метод methods возвращает список всех
# методов, которые можно вызывать для данного объекта. Метод public_methods возвращает список открытых методов
# и принимает параметр, равный по умолчанию true, который говорит, нужно ли включать также методы суперклассов.
# Методы private_methods, protected_methods и singleton_methods тоже принимают такой параметр и возвращают
# именно то что что и ожидается.
class SomeClass

  def initialize
    @a = 1
    @b = 2
  end

  def mymeth
    #...
  end

  protected :mymeth

end

x = SomeClass.new

def x.new_method
  # ...
end
iv = x.instance_variables                        # ["@b", "@a"]

p x.methods.size                                 # 61

p x.public_methods.size                          # 60

p x.public_instance_methods(false).size          # 1

p x.private_methods.size                         # 85
p x.private_methods(false).size                  # 1

p x.protected_methods.size                       # 1
p x.singleton_methods.size                       # 1

# Удаление определений.
# Радикальный способ уничтожить определение - воспользоваться ключевым словом undef (неудивительно, что его
# действие противоположно действию def). Уничтожать можно определения методов локальных переменных и констант
# на верхнем уровне. Хотя имя класса - тоже константа, удалить определение класса таким способом невозможно.
def asbestos
  puts "Теперь не огнеопасно"
end

tax = 0.08

PI = 3

asbestos
puts "PI=#{PI}, tax=#{tax}"

undef asbestos
undef tax
undef PI
# Любое обращение к этим трем именам теперь приведет к ошибке.
# Внутри определения класса, можно уничтожать определения методов и констант в том же контексте, в котором
# они были определены. Нельзя применять undef внутри определения метода, а также к переменной экземпляра.
# Существуют (определены в классе Module) также методы remove_method и undef_method. Разница между ними
# тонкая: remove_method удаляет текущее (или ближайшее) определение метода, а undef_method удаляет его также из всех
# суперклассов, не оставляя от метода даже следа.
class Parent

  def alpha
    puts "alpha: родитель"
  end

  def beta
    puts "beta: родитель"
  end
end

class Child < Parent

  def alpha
    puts "alpha: потомок"
  end

  remove_method :alpha            # Удалить "этот" alpha
  undef_method :beta              # Удалить все beta

end

x = Child.new

x.alpha                           # alpha: родитель
x.beta                            # Ошибка!
# Метод remove_const удаляет константу.
module Math

  remove_const :PI

end

# PI больше нет!

# Отметим, что таким образом можно удалить и определение класса (потому что идентификатор класса - это
# просто константа):
class BriefCandle
  #...
end

out_out = BriefCandle.new
class Object
  remove_const :BriefCandle
end

BriefCandle.new                            # NameError: uninitialized constant BriefCandle
out_out.class.new                          # Еще один экземпляр BriefCandle
# Такие методы, как remove_const и remove_method являются закрытыми (что и понятно). Поэтому во всех примерах
# они вызываются изнутри определения класса или модуля, а не снаружи.

# Ссылки на несуществующие константы
# Метод const_missing вызывается при попытке обратиться к неизвестной константе. В качестве параметра ему
# передается символ, ссылающийся на константу. Ситуация аналогична методу method_missing, который мы рассмотрим далее.
# Чтобы перехватывать обращения к отстутствующим константам глобально, определите следующий метод в самом
# классе Module (это родитель класса Class).
class Module
  def const_missing(x)
    "из Module"
  end
end

class X 
end

p X::BAR             # "из Module"
p BAR                # "из Module"
p Array::BAR         # "из Module"

# Можено выполнить в нем любые действия: вернуть фиктивное значение константы, вычислить его и т.д.
# Воспользуемся классом Roman из главы 6, чтобы трактовать любые последовательности римских цифр, как 
# числовые константы:
class Module
  def const_missing(name)
    Roman.decode(name)
  end
end

year1 = MCMLCCIV                     # 1974
year2 = MMXIV                        # 2014
# Если такая глобальность вам не нужна, определите этот метод на уровне конкретного класса. 
# Тогда он будет вызываться из этого класса и его потомков.
class Alpha
  def self.const_missing(sym)
    "В Alpha нет #{sym}"
  end
end

# В конечном итоге будет вызван method_missing, определенный в классе Object, который и возбудит исключение.
# Чтобы использование метода method_missing было безопасным, всегда определяйте метод respond_to_missing?.
# В этом случае Ruby сможет предоставить результаты как методу respond_to?, так и методу method.
# Ниже приведен пример такой техники:
class CommandWrapper                            # повторно открыть класс

  def respond_to_missing?(method, include_all)
    system("which #{method} > /dev/null")
  end

end

cw = CommandWrapper.new
cw.respond_to?(:foo)                  # false
cw.method(:echo)                      # #<Method: CommandWrapper#echo>
cw.respond_to?(:echo)                 # true
# Второй параметр (include_all) определяет, должен ли метод просматривать также закрытые и защищенные методы.
# В данном примере ни тех, ни других нет, поэтоу их можно игнорировать.
# Хотя метод respond_to_missing? является логическим дополнением к method_missing, Ruby относится к нему 
# безучастно. Можно написать только один из двух методов, если вас не смущает крайне непоследовательное поведение.

# Повышение безопасности с помощью taint
# Многие базовые методы (и, прежде всего eval) ведут себя по-другому или возбуждают исключение, если им
# передают запятнанные данные при повышенном уровне безопасности. Рассмотрим следующие примеры использования строк:
str1 = "puts 'Ответ: "
str2 = ARGV.first.dup                  # "3*79" (продублирована, чтобы разморозить)
str1.tainted?                          # false
str2.tainted?                          # true

str1.taint                             # При желании мы можем изменить состояние запятнанности
str2.untaint

eval(str1)                             # Печатается: Ответ:
puts eval(str2)                        # Печатается: 237

$SAFE = 1

eval(str1)                             # Возбуждается SecurityError: Insecure operation
puts eval(str2)                        # Печатается: 237

# Определение чистильщиков для объектов
# Можно написать код, который будет вызываться, когда сборщик мусора уничтожает объект.
a = "hello"
puts "Для строки 'hello' ид объекта равен #{a.id}"
ObjectSpace.define_finalizer(a) { id puts "Уничтожается #{id}" }
puts "Нечего убирать"
GO.start 
a = nil
puts "Исходная строка - кандидат на роль мусора"
GO.start 
# Этот код выводит следующее:
Для строки 'hello' ид объекта равен 547684890
Нечего убирать
Исходная строка - кандидат на роль мусора
Уничтожается 547684890
# Подчеркнем, что к моментуу вызова чистильщика объект уже фактически уничтожен. Попытка преобразовать 
# идентификатор в ссылку на объект с помощью метода ObjectSpace._id2ref приведет к исключению RangeError с сообщением
# о том, что вы пытаетесь воспользоваться уничтоженным объектом.
# Имейте также в виду, что в Ruby применяется консервативный механизм сборки мусора. Нет гарантии, что любой
# объект будет убран до завершения программы. Однако все это может окзаться ненужным. В Ruby существует
# стиль программирования, в котором для инкапсуляции работы с ресурсами служат блоки. В конце блока ресурс
# освобождается, и жизнь продолжается без помощи чистильщиков.
# Рассмотрим, например, блочную форму метода File.open:
File.open("myfile.txt") do |file|
  line1 = file.gets
  # ...
end
# Здесь в блок передается объект File, а по выходе из блока файл закрывается, причем все это делается под
# контролем метода open. Метод File.open ради эффективности написан на C, но на чистом Ruby он мог выглядеть
# так:
def File.open(name, mode = "r")
  f = os_file_open(name, mode)
  if block_given?
    begin
      yield f 
    ensure
      f.close 
    end
    return nil
  else
    return f 
  end
end
# Мы проверяем наличие блока. Если блок был передан, то мы вызываем его, передавая открытый файл. Делается 
# это в контексте секции begin-end, которая гарантирует, что файл будет закрыт по выходе из блока, 
# даже если произойдет исключение.

# Обход пространства объектов
# Исполняющая система Ruby должна отслеживать все известные объекты (хотя бы для того, чтобы убрать мусор,
# когда на объект больше нет ссылок). Информацию о них можно получить с помощью метода ObjectSpace.each_object.
# Если задать класс или модуль в качестве параметра each_object, то будут возвращены лишь объекты указанного типа:
ObjectSpace.each_object do |obj|
  printf "%20s: %s\n", obj.class, obj.inspect
end

# Печатается:
# Bignum: 2352398269582698756298745692875692384756923
# Bignum: 208450285028750234875023487

# Если вас интересует лишь количество созданных объектов каждого типа, то метод count_objects вернет хэш, 
# в котором ключом является тип объекта, а значением - счетчик.
require 'pp'
p ObjectSpace.count_objects
# {:TOTAL=>33013, :FREE=>284, :T_OBJECT=>2145, :T_CLASS=>901,
   :T_MODULE=>32, :T_FLOAT=>4, :T_STRING=>18999, >T_REGNUM=>167,
   :T_ARRAY=>4715, :T_HASH=>325, :T_STRUCT=>2, :T_BIGNUM=>4,
   :T_FILE=>8, :T_DATA=>1518, :T_MATCH=>205, :T_COMPLEX=>1,
   :T_NODE=>3663, :T_ICLASS=>40}
# Модуль ObjectSpace полезен также для определения чистильщиков объектов.

# Просмотр стека вызовов
# Иногда необходимо знать, кто вызвал метод. Эта информация полезна, если, например, произошло неисправимое
# исключение. Метод caller, определенный в модуле Kernel, дает ответ на этот вопрос.
# Он возвращает массив строк, в котором первый элемент соответствует вызвавшему методу, следующий -
# методу, вызвавшему этот метод, и т.д.
def func1
  puts caller[0]
end

def func2
  func1
end

# Отслеживание изменений в определении класса или объекта
# А зачем собственно? Кому интересны изменения, которым подвергался класс?
# Одна возможная причина - желание следить за состоянием выполняемой программы на Ruby. Быть может,
# мы реализуем графический отладчик, который должен обновлять список методов, добавляемых "на лету".
# Другая причина: мы хотим вносить соответствующие изменения в другие классы. Например, мы разрабатываем
# модуль, который можно включить в определение любого класса. С момента включения будут трассироваться 
# любые обращения к методам этого класса. Возможная реализация такого модуля показана ниже:
module Tracing

  def self.hook_method(const, meth)
    const.class_eval do
      alias_method "untraced_#{meth}", "#{meth}"
      define_method(method) do |*args|
        puts "вызван метод #{meth} с параметрами (#{args.join(', '})"
        send("untraced_#{meth}", *args)
      end
    end
  end

  def self.included(const)
    const.instance_methods(false).each do |m|
      hook_method(const, m)
    end

    def const.method_added(name)
      return if @disable_method_added
      puts "Метод #{name} добавлен в класс #{self}"
      @disable_method_added = true
      Tracing.hook_method(self, name)
      @disable_method_added = false
    end

    if const.is_a?(Class)
      def const.inherited(name)
        puts "Класс #{name} унаследован от #{self}"
      end
    end

    if const.is_a?(Module)
      def const.extended(name)
        puts "Класс #{name} расширил себя с помощью #{self}"
      end

      def const.included(name)
        puts "Класс #{name} включил в себя #{self}"
      end
    end

    def const.singleton_method_added(name, *args)
      return if @disable_singleton_method_added
      return if name == :singleton_method_added

      puts "Метод класса #{name} добавлен в класс #{self}"
      @disable_singleton_method_added = true
      singleton_class = (class << self; self; end)
      Tracing.hook_method(singleton_class, name)
      @disable_singleton_method_added = false
    end
  end
end
# В этом модуле два основных метода. Первый, trace_method, работает прямолинейно. При добавлении метода
# ему сразу назначается синоним untraced_name. Исходный метод заменяется кодом трассировки, который выводит
# имя и параметры метода, а затем вызывает метод, к которому было обращение.
# Обратите внимание на использование конструкции alias_method. Работает она почти так же, как alias, 
# но только для методов (да и сама является методом, а не ключевым словом). Принимает имена методов в виде
# символов или строк.
# Второй метод, included, вызывается при каждой вставке модуля в класс. Наша версия делает несколько вещей
# для отслеживания будущих вызовов метода и изменений в классе.
# Во-вторых, она вызывает метод trace_method для каждого метода, уже определенного в целевом классе.
# Это дает возможность трассировать методы, которые были определены до включения модуля Tracing. Затем она
# определяет метод класса method_added. В результате любой добавленный позже метод будет обнаружен и протрассирован.
class MyClass
  def first_meth
  end
end

class MyClass 
  include Tracing

  def second_meth(x, y)
  end

  # Выводится: метод second_meth добавлен в класс MyClass
end

m = MyClass.new
m.first_meth
# Выводится: вызван метод first_meth с параметрами ()
m.second_meth(1, 'cat')
# Выводится: вызван метод second_meth с параметрами (1, 'cat)

# Далее следуют условные предложения, к которым мы вернемся чуть позже. Наконец, модуль обнаруживает добавление
# новых синглетных методов, для чего определяет метод singleton_method_added в трассирующем классе.
# (Напомним, что синглетный метод - то, что мы обычно называем методом класса, поскольку Class - это объект.)
class MyClass
  def self.a_class_method(options)
  end
end

MyClass.a_class_method(green: "super")

# Выводится:
# Метод класса a_class_method добавлен в класс MyClass
# Метод a_class_method вызван с параметрами ({:green=>"super"})

# Обратный вызов singleton_method_added определен последним, чтобы не печаталась трассировка других методов
# класса, добавленных модулем Tracing. Отметим также, что (быть может, вопреки ожиданиям) модуль может
# отслеживать добавление в класс самого себя, следовательно, мы должны явно исключить его из трассировки.
# В первом условном предложении определяется метод inherited для каждого целевого класса Class.
# Впоследствии он будет вызываться каждый всякий раз, как этому классу наследует какой то другой:
class MySubClass < MyClass
end

# Выводится: Класс MySubClass унаследован от MyClass

# Наконец, в условном предложении для целей типа Module определяются обратные вызовы included и extended,
# чтобы можно было трассировать операции включения и расширения целевого модуля:
module MyModule
  include Tracing
end

class MyClass
  include MyModule
  extend MyModule
end

# Выводится:
# Класс MyClass включил в себя MyModule
# Класс MyClass расширил себя с помощью MyModule

# Мониторинг выполнения программы
# Программа на Ruby может следить за собственным выполнением. У этой возможности есть много применений:
# большая часть их с связана с профилированием и отладкой и будет рассмотрена далее.
# В некоторых случаях библиотеки вообще не нужны, потому что задачу можно решить на Ruby, воспользовавшись
# интроспекцией. Такой подход резко снижает производительность (и потому в режиме  эксплуатации не рекомендуется)
# но, тем не менее, класс TracePoint позволяет вызвать написанный нами код при возникновении интересующего 
# события. В примере ниже трассируются вызовы и возвраты из методов, а глубина вложенности обозначается отступами:
def factorial(n)
  (l..n).inject(:*) || 1
end

@call_depth = 0

TracePoint.trace(:a_call) do |tp|
  @call_depth += 1
  print "#{tp.defined}:#{sprintf("%-4d", tp.lineno) } #{" " * @depth}"
  puts "#{tp.defined_class}##{tp.method_id} => #{tp.return_value}"
  @call_depth -= 1
end

factorial(4)

# Здесь мы воспользовались методом TracePoint.trace, это просто сокращенный способ вызвать new, а затем
# enable. Можно также трассировать одиночный блок кода, передав его методу TracePoint#enable.
# При выполнении этой программы будет напечатано следующее:
factorial.rb:12  #<Class:TracePoint>#trace
factorial.rb:12  #<Class:TracePoint>#trace =>
                   #<TracePoint:0x007ffe8a893f10>
factorial.rb:1   Object#factorial
factorial.rb:2     Enumerable#inject
factorial.rb:2       Range#each
factorial.rb:2         Fixnum#*
factorial.rb:2         Fixnum#* => 2
factorial.rb:2         Fixnum#*
factorial.rb:2         Fixnum#* => 6
factorial.rb:2         Fixnum#*
factorial.rb:2         Fixnum#* => 24
factorial.rb:2       Range#each => 1..4
factorial.rb:2     Enumerable#inject => 24
factorial.rb:3   Object#factorial => 24
# С этим методом тесно связан метод Kernel#trace_var, который вызывает указанный блок при каждом присваивании
# значения глобальной переменной.
# Если вы хотите трассировать все вообще, то вместо тогоо чтобы писать свои трассировщики, можете затребовать
# стандартную библиотеку tracer. Ниже показана программа factorial.rb:
def factorial(n)
  (l..n).inject(:*) || 1
end

factorial(4)

# Имея эту программу, мы можем просто загрузить tracer из командной строки:
$ ruby -disable-gems -r tracer factorial.rb
# 0:factorial.rb:1::-: def factorial(n)
# 0:factorial.rb:5::-: factorial(4)
# 0:factorial.rb:1:Object:>: def factorial(n)
# 0:factorial.rb:2:Object:-:  (l..n).inject(:*) || 1
# 0:factorial.rb:2:Object:-:  (l..n).inject(:*) || 1
# 0:factorial.rb:3:Object:<: end

# Библиотека tracer выводит номер потока, имя файла и номер строки, имя класса, тип события и исполняемую
# строку исходного текста трассируемой программы. Бывают следующие типы событий: '-' - исполняется строка
# исходного текста, '>' - вызов, '<' - возврат, 'C' - класс, 'E' - конец. (Если вы не отключили Rubygems
# или затребовали еще какую то библиотеку, то будет напечатано много дополнительных строк.)
# Описанные приемы можно использовать для построения весьма развитых средств отладки и инструментовки.

# Создание потоков и манипулирование ими
# В любой программе есть по меньшей мере один поток - начальный поток управления, который мы называем "главным"
# Программа становится многопоточной, когда запускает дополнительные потоки.
# Создать поток в Ruby просто. Достаточно вызвать метод new и присоединить блок, который будет исполняться в потоке:
thread = Thread.new do
  # Предложения, исполняемые в потоке...
end
# Синонимом new является метод fork, поэтому для создания потока можно было бы написать Thread.fork вместо
# Thread.new. Вне зависимости от имени возвращается экземпляр класса Thread. С его помощью можно управлять
# потоком. А если нужно передать потоку параметры? Достаточно передать их методу Thread.new:
thread2 = Thread.new(99, 100) do |a, b|
  # начальное значение параметра a равно 99
  # начальное значение параметра b равно 100
end
# Таким образом, блок в этом примере принимает два параметра, a и b, которые в начальный момент равны 99 и 100.
# Поскольку в основе потоков лежат обычные блоки кода, поток может обращаться к переменным из той области
# видимости, в которой был создан. Это значит, что следующий поток может изменять значения x и y, поскольку
# эти переменные находились в области видимости, когда создавался ассоциированный с потоком блок.
x = 1
y = 2

thread3 = Thread.new(99, 100) do |a, b|
  # x и y видимы и могут быть изменены!
  x = 10
  y = 11
end

puts x, y 
# Опасность таких действий таится в ответе на вопрос: когда. Когда именно изменяютя значения x и y?
# Мы можем быть уверены, что это происходит после начала выполнения потока thread3, но это и все что можно
# Начав рааботать, поток живет своей жизнью, и если не предпринять каких то мер по синхронизации, вы никогда
# не узнаете, как быстро он продвигается вперед. Из-за этой непредсказуемости невозможно сказать, что будет
# напечатано в примере выше. Если thread3 завершается очень быстро, то, возможно, будут напечатаны значения
# 10 и 11. Наоборот, если thread3 задержался на старте, то могут быть напечатаны 1 и 2ю Существует даже шанс
# хотя и небольшой, что мы увидим значение 1, а сразу за ним 11, - если thread3 и главный поток идут ноздря
# в ноздрю. В реальных программах мы всеми силами стремимся избежать такого неопределенного поведения.

# Доступ к поточно-локальным переменным
# Так как же все-таки программировать потоки, которые могли бы разделять данные с прочими частями программы,
# не портя переменные вне своей области видимости? К счастью, в Ruby для этой цели предусмотрен специальный
# механизм. Хитрость в том, чтобы рассматривать объект Thread как хэш и читать и изменять значения по ключу.
# К таким поточно-локальным данным можно обращаться из любого места внутри и вне потока, получив тем самым
# удобный механизм совместного использования. Ниже приведен пример работы программы с поточно-локальными данными:
thread = Thread.new do
  t = Thread.current 
  t[:var1] = "Это строка"
  t[:var2] = 365
end

sleep 1                   # Пусть поток немного побездельничает

# Доступ к локальным данным потока извне...

x = thread[:var1]         # "Это строка"
y = thread[:var2]         # 365

has_var2 = thread.key?("var2") # true
has_var3 = thread.key?("var3") # false

# Как видим, поток может инициализировать собственные локальные данные; для этого нужно вызвать метод 
# Thread.current, который возвращает текущий экземпляр Thread, а затем рассматривать этот объект как хэш.
# В классе Thread имеется метод экземпляра key?, который сообщает, было ли присвоено значение указанному
# ключу. Еще одна приятная особенность поточно-локальных данных - тот факт, что они не исчезают даже после
# того, как создавший их поток завершил работу.
# Следует понимать, что хотя потоки обращаются со своими поточно-локальными данными как с хэшем, на самом
# деле это ненастоящий хэш: у него нет большинства привычных методов Enumerable, в частности each и find.
# Но еще важнее то, то потоки очень разборчивы в части допустимых ключей поточно-локальных данных. Ключами
# могут быть только символы и строки, причем неявно преобразуются в символы. Это видно из примера:
thread = Thread.new do 
  t = Thread.current 
  t["started_as_a_string"] = 100 
  t[:started_as_a_symbol] = 101 
end

sleep 1              # Пусть поток немного побездельничает

a = thread[:started_as_a_string]          # 100
b = thread["started_as_a_symbol"]         # 101
# Важно отметить, что поточно-локальные данные решают проблему гдеб предоставляя место для размещения данных,
# но, не решают проблему когда: без синхронизации у нас нет ни малейшего представления о том, когда поток
# соберется что-то сделать со своими локальными данными. Распространенное решение - "вернуть" поточно-лоокальные
# данные, когда поток завершает выполнение. В этом случае никакой синхронизации не нужно, потому что поток уже завершился.

# Опрос и изменение состояния потока
# В классе Thread есть несколько полезных методов класса. Метод list возвращает массив "живых" потоков, метод
# main возвращает ссылку на главный поток программы, который породил все остальные, а метод current 
# позволяет потоку идентифицировать себя.
t1 = Thread.new { sleep 100 }

t2 = Thread.new do 
  if Thread.current == Thread.main 
    puts "Это главный поток."             # Не печатается
  end
  1.upto(1000) { sleep 0.1 }
end

count = Thread.list.size 
 
if Thread.list.include?(Thread.main)
  puts "Главный поток жив."               # Печатается всегда!
end 

if Thread.current == Thread.main 
  puts "Я главный поток."                 # Здесь печатается... 
end

# Методы exit, pass, start, stop и kill служат для управления выполнением потоков (как изнутри, так и извне):
# В главном потоке...
Thread.kill(t1)                           # Завершить этот поток
Thread.pass                               # Уступить свой квант
t3 = Thread.new do                        
  sleep 20
  Thread.exit                             # Выйти из потока
  puts "Так не бывает!"                   # Никогда не выполняется
end

Thread.kill(t2)                           # Завершить t2

# Выйти из главного потока (все остальные тоже завершаются)
Thread.exit

# Отметим, что не существует метода экземпляра stop, поэтому поток может приостановить собственное выполнение,
# но не выполнение другого потока.
# Существуют различные методы для опроса состояния потока. Метод экземпляра alive? сообщает, является ли
# данный поток "живым" (не завершил выполнение), а метод stop? - находится ли он в состоянии "приостановлен".
# Отметим, что методы alive? и stop? - не полные противоположности: оба возвращают true, если поток спит, 
# потому что спящий поток 1) еще жив и 2) в данный момент ничего не делает.
count = 0 
t1 = Thread.new { loop { count += 1 } }
t2 = Thread.new { Thread.stop }

sleep 1                    # Пусть поток немного побездельничает

flags = [t1.alive?,        # true
         t1.stop?,         # false
         t2.alive?,        # true
         t2.stop?]         # true

# Получить состояние потока позволяет метод status. Множество возвращаемых им значений напоминает сборную
# солянку: если поток выполняется, метод возвращает значение "run", если приостановлен, спит или ожидает
# завершения ввода-вывода - то "sleep". Есил поток нормально завершился, возвращается false, а если трагически
# погиб в результате исключения, то nil. Все это иллюстрируется в следующем примере:
t1 = Thread.new { loop {} }
t2 = Thread.new { sleep 5 }
t3 = Thread.new { Thread.stop }
t4 = Thread.new { Thread.exit }
t5 = Thread.new { raise "exception" }

sleep 1                    # Пусть поток немного побездельничает

s1 = t1.status             # "run"
s2 = t2.status             # "sleep"
s3 = t3.status             # "sleep"
s4 = t4.status             # false 
s5 = t5.status             # nil

# Потоки знают о глобальной переменной $SAFE, но на самом деле она вовсе не такая глобальная, как кажется,
# потому что у каждого потока она своя. Выглядит противоречиво, но стоит ли жаловаться, если она позволяет
# разным потокам работать с разным уровнем безопасности? Поскольку переменная $SAFE отнюдь не является глобальной,
# когда речь заходит о потоках, у метода экземпляра Thread имеется метод safe_level, который возвращает 
# уровень безопасности данного потока.
t1 = Thread.new { $SAFE = 1; sleep 5 }
t2 = Thread.new { $SAFE = 3; sleep 5 }
sleep 1
lev0 = Thread.main.safe_level       # 0
lev1 = t1.safe_level                # 1
lev2 = t2.safe_level                # 3

# У потоков в Ruby имеется числовой приоритет: чем он больше, тем чаще планировщик выделяет потоку процессор.
# Узнать и изменить приоритет потока позволяет акцессор priority:
t1 = Thread.new { loop { sleep 1 } }
t2 = Thread.new { loop { sleep 1 } }
t2.priority = 3   # Установить для потока t2 приоритет 3
p1 = t1.priority  # 0
p2 = t2.priority  # 3

# Специальный метод pass позволяет передать управление планировщику. Иными словами, поток просто уступает
# свой временной квант, но не останавливается и не засыпает.
t1 = Thread.new do 
  Thread.pass
  puts "Первый поток"
end

t2 = Thread.new do 
  puts "Второй поток"
end

sleep 3        # Дать возможность потокам переключиться

# В этом искусственном примере второй поток, скорее всего, напечатает сообщение раньше первого. Если убрать
# вызов pass, то, наверное, первый поток - запущеный раньше - выиграл бы состязание. Но, конечно, для
# несинхронизированных потоков никаких гарантий не дается. Метод pass и приоритеты потоков - это лишь пожелания
# планировщику, для синхронизации потоков они не предназначены.
# Выполнение приостановленного потока можно возобновить методами run или wakeup:
t1 = Thread.new do 
  Thread.stop
  puts "Здесь есть изумруд."
end

t2 = Thread.new do 
  Thread.stop
  puts "Вы находитесь в точке Y2."
end

sleep 0.5          # Пусть потоки запустятся

t1.wakeup
t2.run

# Между этими методами есть тонкое различие. Метод wakeup изменяет состояние потока, так что он становится
# готовым к выполнению, но не запускает его немедленно. Метод же run пробуждает поток и сразу же планирует
# его выполнение. В данном случае мы получили следующий результат:
Вы находитесь в точке Y2.
Здесь есть изумруд.
# Повторим еще раз - в зависимости от причуд планировщика и фазы луны строки могли бы быть напечатаны в
# другом порядке. Ни в коем случае не следует реализовывать синхронизацию потоков на основе методов
# stop, wakeup и run.
# Метод экземпляра raise возбуждает исключение в потоке, от имени которого вызван. Его необязательно вызывать
# в том потоке, которому адресовано исключение.
factorial1000 = Thread.new do 
  begin
    prog = 1 
    1.upto(1000) { |n| prod *= n }
    puts "1000! = #{prod}"
  rescue
    # Ничего не делать...
  end
end

sleep 0.01              # На вашей машине значение может быть иным.
if factorial1000.alive? 
  factorial1000.raise("Стоп!")
  puts "Вычисление было прервано!"
else
  puts "Вычисление успешно завершено."
end
# Поток, запущенный в этом примере, пытается вычислить факториал 1000. Если для этого не хватило одной 
# сотой секунды, то главный поток потеряет терпение и завершит его. Следовательно, на относительно медленной
# машине будет напечатано сообщение "Вычисление было прервано!"

# Назначение рандеву (и получение возвращенного значения)
# Иногда главный поток хочет дождаться завершения другого потока. Для этой цели предназначен метод join:
t1 = Thread.new { do_something_long() }

do_something_brief()
t1.join                 # Ждать завершения t1
# Типичная ошибка - запустить несколько потоков, а затем позволить главному потоку завершиться. Беда в том
# что вместе с главным потоком Ruby завершает и весь процесс. Например, следующий код никогда не напечатал бы
# окончательный ответ, не будь в конце вызова join:
meaning_of_life = Thread.new do 
  puts "Смысл жизни заключается в..."
  sleep 2
  sleep 42
end

meaning_of_life.join    # Дождаться завершения потока

# Существует полезная идиома - вызывать метод join, чтобы дождаться завершения остальных "живых" потоков.
Thread.list.each { |t| t.join if t != Thread.current }
# Обратите внимание на проверку того, то поток не является текущим, перед тем как вызывать join.
# Если поток, пусть даже главный, попытается вызвать join для самого себя, произойдет ошибка.
# Если два потока попытаются одновременно вызвать join друг для друга, возникнет взаимоблокировка.
# Интерпретатор обнаружит это и возбудит исключение.
thr = Thread.new { sleep 1; Thread.main.join }

thr.join          # Взаимоблокировка!
# Как мы уже видели, с потоком связан блок. Всякий, кто хоть немного знаком с Ruby, понимает, что блок
# может возвращать значение. Метод value неявно вызывает join и ждет, пока указанный поток завершится, а
# потом возвращает значение последнего вычисленного в потоке выражения.
max = 10000
t = Thread.new do 
  sleep 0.2       # Имитировать глубокое раздумье
  42
end

puts "Секретное значение равно #{t.value}"

# Обработка исключений
# Что произойдет, если в потоке возникнет исключение? При нормальных обстоятельствах исключение, возникшее
# в дополнительном потоке, не возбуждается в главном. Ниже приведен пример потока, возбуждающего исключение:
t1 = Thread.new do 
  puts "Hello"
  sleep 1
  raise "какое-то исключение"
end

t2 = Thread.new do 
  sleep 2
  puts "Привет из другого потока"
end

sleep 3
puts "Конец"
# В этом примере оба потока печатают свой привет, а главный поток возвещает о конце.

# Исключение, возникшее внутри потока, не возбуждается, пока для этого потока не будет вызван метод join
# или value. Проверить, что поток завершился с ошибкой, и известить об этом, должен какой то другой поток.
# Ниже показано, как безопасно перехватить исключение, возбужденное в потоке:
t1 = Thread.new do
  raise "О нет!"
  puts "Это никогда не печатается"
end

begin
  t1.status          # nil означает, что произошло исключение
  t1.join
rescue => e  
  puts "Поток возбудил исключение #{e.class}: #{e.message}"
end

 # В этом примере будет напечатано сообщение "Поток возбудил исключение: О нет!". Важно, чтобы исключения
 # в потоках возбуждались в известной точке, чтобы их можно было перехватить или возбудить повторно, не
 # прерывая критическую секцию в каком-то другом потоке.
 # При отладке многопоточной программы иногда бывает полезен флаг abort_on_exception. Если он установлен в true
 # (в конкретном потоке или глобально в классе Thread), то неперехваченное исключение завершает все работающие
 # потоки.
 # Попробуем выполнить самый первый пример, присвоив флагу abort_on_exception значение true в потоке t1:
 t1 = Thread.new do 
  puts "Hello"
  sleep 1
  raise "какое-то исключение"
 end
 
 t1.abort_on_exception = true         # Ах, какой фейерверк!

 t2 = Thread.new do
  sleep 2 
  puts "Привет из другого потока"
 end

 sleep 3
 puts "Конец"

# В данном случае печатается только один "Привет", потому что неперехваченное исключение в потоке t1 завершает
# как главный поток, так и t2.
# Метод t1.abort_on_exception влияет на поведение только одного потока, тогда как метод класса Thread.abort_on_exception
# завершает все потоки, если хотя бы в одном из них возникло исключение.
# Отметим, что эту возможность следует применять только во время разработки или отладки, потому ччто она 
# эквивалентна вызову Thread.list.each(&:kill). Но по иронии судьбы метод kill как раз не является потокобезопасным.
# Используйте kill или abort_on_exception только в ходе отладки или для завершения потоков, относительно
# которых вы твердо уверены, что это безопасно. Возможно, принудительно завершаемый поток удерживает блокировку
# или еще не выполнил код очистки в блоке ensure, то и другое может оставить программу в ошибочном и не 
# допускающем восстановления состоянии.

# Группы потоков
# Группа потоков - это механизм управления логически связанными потоками. По умолчанию все потоки принадлежат
# группе Default (это константа класса). Но если создать новую группу, то в нее можно будет помещать потоки.
# В любой момент времени поток может принадлежать только одной группе. Если поток помещается в группу, то он
# автоматически удаляется из той группы, которой принадлежал ранее.
# Метод класса ThreadGroup.new создает новую группу потоков, а метод экземпляра add помещает поток в группу.
t1 = Thread.new("file1") { sleep(1) }
t2 = Thread.new("file2") { sleep(2) }

threads = ThreadGroup.new
threads.add t1
threads.add t2

# Метод экземпляра list возвращает массив всех потоков, принадлежащих данной группе.
# Подсчитать все "живые" потоки в группе this_group
count = 0
this_group.list.each { |x| count += 1 if x.alive? }
if count < this_group.list.size 
  puts "Некоторые потоки в группе this_group уже скончались."
else
  puts "Все потоки в группе this_group живы."
end
# У объектов класса ThreadGroup имеется также метод со странным названием enclose, который, как правило, 
# не дает помещать в группу новые потоки:
tg = ThreadGroup.new 
tg.enclose                    # Запереть эту группу
tg.add Thread.new {sleep 1}   # Ба-бах!
# Оговорка "как правило" необходима, потому что если новый поток запущен из потока, уже находящегося в 
# запертой группе, то он так в этой группе и останется. У группы потоков есть метод экземпляра enclosed?,
# который возвращает true, если группа заперта.

# В классе ThreadGroup можно добавить немало полезных методов. В примере ниже показаны методы для возобновления
# всех потоков, принадлежащих группе, для группового ожидания потоков (с помощью join) и для группового
# завершения потоков:
class ThreadGroup 

  def wakeup
    list.each { |t| t.wakeup }
  end

  def join 
    list.each { |t| t.join if t != Thread.current }
  end

  def kill 
    list.each { |t| t.kill }
  end

end
# Следует иметь ввиду, что когда поток завершается, он автоматически удаляется из группы. Так что из того
# что вы поместили поток в группу, вовсе не следует, что он по-прежнему будет пребывать там через десять
# минут или хотя бы через десять секунд.

# Синхронизация потоков
# Почему необходима синхронизация? Потому что из-за "чередования" операций доступ к переменным и другим сущностям
# может осуществляться в порядке, который не удается установить путем чтения исходного текста отдельных потоков.
# Два и более потоков, обращающихся к одной и той же переменной, могут взаимодействовать между собой 
# непредвиденными способами, и отлаживать такую программу очень трудно.
# Рассмотрим простой пример:
def new_value(i)
  i + 1
end

x = 0

t1 = Thread.new do 
  1.upto(1000000) { x = new_value(x) }
end

t1.join
t2.join
puts x 
# Сначала переменная x равна 0. Затем мы запускаем два потока и каждый увеличивает ее значение на единицу
# миллион раз, вызывая метод new_value. В конце печатается значение x. Логика подсказывает, что должно быть
# напечатано 2000000. Однако иногда печатается только один миллион!
# При выполнении этой программы под управлением jRuby результат оказался еще более неожиданным: 1143345
# в одном прогоне, 1077403 во втором и 1158422 в третьем. Уж не наткнулись ли мы на чудовищную ошибку в Ruby?
# Вовсе нет. Мы предполагали, что инкремент целого числа - атомарная (неделимая) операция. Но это не так.
# Рассмотрим последовательность выполнения приведенной выше программы. Поместим поток t1 слева, а поток t2 справа
# Каждый квант времени занимает одну строчку и предполагается, что к моменту, когда был сделан этот
# мгновенный снимок, переменная x имела значение 123.
t1                                                             t2
--------------------------------------  --------------------------------------------------
Прочитать значение x (123)
                                        Прочитать значение x (123)
Увеличить значение на 1 (124)
                                        Увеличить значение на 1 (124)
Записать 124 в x     
                                        Записать 124 в x 
# Ясно, что каждый поток увеличивает на 1 то значение, которое видит. Но не менее ясно и то, что после
# увеличения на 1 обоими потоками x оказалась равно всего 124. Мы сознательно ухудшили ситуацию в этом
# примере, введя метод new_value и тем самым увеличив интервал времени между чтением x и записью увеличенного
# значения. Даже крохотная задержка, связанная с единственнымм вызовом функции, может кардинально уменьшить число
# правильных операций инкремента.
# Тот факт, что MRI иногда дает правильный результат, может привести невнимательного наблюдателя к выводу
# что этот код потокобезопасен. Проблему маскирует побочный эффект наличия в MRI глобальной блокировки
# интерпретатора (GIL), из-за которой в каждый момент времени может выполняться только один поток. Но, как
# видите, даже GIL не помогает MRI надежно решить эту проблему синхронизации и результат все равно может 
# оказаться неверным.
# И это лишь самая простая из проблем, возникающих в связи с синхронизацией. Для решения более сложных,
# характеризуемых тем, что программа "почти всегда работает", приходится прилагать серьезные усилия, это
# предмет изучения специалистами в области теоретической информатики и математики.

# Простая синхронизация
# Простой способ синхронизации дает метод Thread.exclusive. Он определяет критическую секцию в программе.
# Когда поток входит в критическую секцию программы, гарантируется, что никакой другой поток не войдет в нее,
# пока первый не выйдет.
# Использовать метод Thread.exclusive просто: нужно лишь передать ему блок.
# В следующем примере мы переработали код предыдущего, воспользовавшись методом Thread.exclusive для 
# задания критической секции, которая защищает уязвимые участки программы.
def new_value(i)
  i + 1
end

x = 0

t1 = Thread.new do 
  1.upto(1000000) do
    Thread.exclusive { x = new_value(x) }
  end
end

t2 = Thread.new do 
  1.upto(1000000) do
    Thread.exclusive { x = new_value(x) }
  end
end

t1.join
t2.join
puts x 

# И хотя мы почти ничего не изменили в коде, последовательность выполнения изменилась. Вызов Thread.exclusive
# не дает потокам наступать друг другу на пятки.
t1                                         t2
-----------------------------------        --------------------------------------------

Прочитать значение x (123)
Увеличить значение на 1 (124)
Записать 124 в x 
                                           Прочитать значение x (124)
                                           Увеличить значение на 1 (125)
                                           Записть 124 в x 
# На практике с методом Thread.exclusive связан ряд проблем, и самая главная - широта его воздействия.
# Вызывая Thread.exclusive, мы блокируем почти все остальные потоки, включая и ни в чем не повинные,
# которые и не собирались изменять наши драгоценные данные.
# Слово "почти" подводит еще к одной проблеме: хотя эффект Thread.exclusive распространяет очень широко, 
# этот метод все не является воздухопроницаемым. При некоторых условиях другой поток может работать, несмотря
# на поставленную Thread.exclusive блокировку. Например, если запустить второй поток изнутри критической
# секции, то он будет выполняться.
# Поэтому использование Thread.exclusive лучше ограничить лишь такими простыи ситуациями, как в примере выше.
# По счастью, в Ruby есть и другие, более гибкие, средства синхронизации.

# Синхронизация доступа с помощью мьютекса
# Одно из них - мьютекс (сокращение от "mutual exclusion" - взаимное исключение). Чтобы увидеть мьютекс
# в действии, переработаем предыдущий пример с увеличением счетчика.
require 'thread'

def new_value(i)
  i + 1
end

x = 0
mutex = Mutex.new

t1 = Thread.new do 
  1.updo(1000000) do 
    mutex.lock 
    x = new_value(x)
    mutex.unlock
  end
end

t2 = Thread.new do 
  1.upto(1000000) do 
    mutex.lock 
    x = new_value(x)
    mutex.unlock
  end
end

t1.join
t2.join
puts x 
# Можно сказать, что объекты класса Mutex реализуют синхронизацию с узкой областью действия: мьютекс гарантирует,
# что в данным момент времени только один поток может успешно вызвать метод lock. Если два потока попытаются
# одновременно вызвать lock, то неудачник будет приостановлен до тех пор, пока более удачливый соперник -
# сумевший захватить блокировку - не вызовет unlock. Поскольку действие мьютекса распространяется только
# на потоки, пытающиеся захватить именно его, то мы получаем синхронизацию, не приостанавливая все потоки, кроме одного.
# Помимо метода lock, в классе Mutex есть также метод try_lock. Он отличается от lock тем, что если мьютекс
# уже захвачен другим потоком, то он не дожидается освобождения, а сразу возвращает false:
require 'thread'

mutex = Mutex.new 
t1 = Thread.new do 
  mutex.lock
  sleep 10
end

sleep 1 

t2 = Thread.new do 
  if mutex.try_lock 
    puts "Захватил"
  else
    puts "Не смог захватить"                    # Печатается сразу же 
  end
end
# Эта возможность полезна, если поток не хочет приостанавливаться. Есть также метод synchronize, 
# который ставит блокировку:
x = 0
mutex = Mutex.new 

t1 = Thread.new do 
  1.upto(1000000) do 
    mutex.synchronize { x = new_value(x) }
  end
end
# Наконец, существует библиотека mutex_m, где определен модуль Mutex_m, который можно подмешивать к классу
# (или использовать для расширения объекта).
# У такого расширенного объекта будут все методы мьютекса, так что он сам может выступать в роли мьютекса.
require 'mutex_m'

class MyClass 
  include Mutex_m

  # Теперь любой объект класса MyClass может вызывать
  # методы lock, unlock, synchronize ...
  # Внешние объекты также могут вызывать эти
  # методы для объекта MyClass.
end

# Встроенные классы очередей
# В библиотеке thread.rb есть два класса, которые иногда бывают полезны. Класс Queue реализует потокобезопасную
# очередь, доступ к обоим концам которой синхронизирован. Это означает, что разные потоки могут, ничего
# не опасаясь, работать с такой очередью. Класс SizedQueue отличается от предыдущего тем, что позволяет ограничить
# размер очереди (число элементов в ней).
# Оба класса имеют практически один и тот же набор методов, поскольку SizedQueue наследует Queue.
# Правда, в подклассе определен еще акцессор  max, позволяющий получить и установить максимальный размер очереди.
buff = SizedQueue.new(25)
upper1 = buff.max                       # 25
# Увеличить размер очереди...     
buff.max = 50
upper2 = buff.max                       # 50

# В примере ниже приведено решение задачи о производителе и потребителе. Для производителя задержка
# (аргумент sleep) чуть больше, чем для потребителя, чтобы единицы продукции "накапливались".
require 'thread'

buffer = ThreadQueue.new(2)

producer = Thread.new do 
  item = 0
  loop do 
    sleep(rand * 0.1)
    puts "Производитель произвел #{item}"
    buffer.enq item
    item += 1
  end
end

consumer = Thread.new do 
  loop do 
    sleep( (rand 0.1) + 0.09)
    item = buffer.deq 
    puts "Потребитель потребил #{item}"
    puts " ожидает = #{bufffer.num_waiting}"
  end
end

sleep 10      # Работать 10 секунда, потом завершить оба потока.

# Чтобы поместить элемент в очередь и извлечь из нее, рекомендуется применять соответственно методы enq и deq.
# Можно было бы для помещения в очередь пользоваться также методом push, а для извлечения - методами pop и shift,
# но их названия не так мнемоничны в применении к очередям.
# Метод empty? проверяет, пуста ли очередь, а метод clear опустошает ее. Метод size (и его синоним length)
# возвращает число элементов в очереди.

# Предполагается, что другие потоки не мешают ...

buff = Queue.new
buff.enq "one"
buff.enq "two"
buff.enq "three"
n1 = buff.size                     # 3
flag1 = buff.empty?                # false
buff.clear
n2 = buff.size                     # 0
flag2 = buff.empty?                # true
# Метод num_waiting возвращает число потоков, ожидающих доступа к очереди. Если размер очереди не ограничен, 
# то эти потоки, ожидающие возможности удалит элементы; для объекта SizedQueue включаются также потоки, ожидающие
# возможности добавить элементы в очередь.
# Необязательный параметр non_block метода deq в классе Queue по умолчанию равен false.
# Если же он равен true, то при попытке извлечь элемент из пустой очереди он не блокирует поток, 
# а возбуждает исключение ThreadError.

# Другие способы синхронизации
# Еще один механизм синхронизации - это монитор, который в Ruby реализован в библиотеке monitor.rb.
# Это более развитый по сравнению с мьютексом механизм, основное отличие состоит в том, что захваты одного
# и того же мьютекса не могут быть вложенными, а монитора - могут.
# Как и испанская инквизиция, вложенные блокировки приходят, когда их никто не ждет. В самом дела, вряд ли
# кто-нибудь станет писать такой код:
@mutex = Mutex.new

@mutex.synchronize do 
  @mutex.synchronize do 
    #...
  end
end
# Но это не значит, что вложенные блокировки вообще не возможны. Что если обращение к synchronize 
# находится в рекурсивном методе? Или метод захватывает мьютекс, а потом, не чуя за собой вины, вызывает 
# какой-то другой метод?
def some_method
  @mutex = Mutex.new 

  @mutex.synchronize do 
    #...
    some_other_method
  end
end

def some_other_method
  @mutex.synchronize do                       # Взаимоблокировка!
  #...
  end
end

# В обоих случаях - по крайнем мере, при использовании мьютекса - результатом будет взаимоблокировка
# с последующим не красящим программу исключением. Но поскольку мониторы допускают вложенные блокировки, 
# следующий код работает безо всяких проблем:
def some_method
  @monitor = Monitor.new 

  @monitor.synchronize do 
    #...
    some_other_method
  end
end

def some_other_method
  @monitor.synchronize do                     # Никаких проблем!!
  #...
  end
end
# Как и мьютексы, мониторы Ruby бывают двух видов: класс Monitor, с которым мы только что познакомились, 
# и модуль с педантично выбранным именем MonitorMixin, который позволяет использовать в качестве монитора
# объект любого класса:
class MyMonitor
  include MonitorMixin
end

# Класс ConditionVariable в библиотеке monitor.rb дополнен по сравнению с определением в библиотеке thread.
# У него есть методы wait_untill и wait_while, которые блокируют поток в ожидании выполнения условия. 
# Кроме того, возможен таймаут при ожидании, поскольку у метода wait имеется параметр timeout, равный
# количеству секунд (по умолчанию nil)
# Поскольку примеры работы с потоками у нас кончаются, то ниже мы предлагаем реализацию  классов Queue 
# и SizedQueue с помощью монитора.
# Немного модифицированная версия кода, написанного Шуго Маэда(Shugo Maeda)
require 'monitor'

class OurQueue

  def initialize
    @que = []
    @monitor = Monitor.new 
    @empty_cond = @monitor.new_cond 
  end

  def enq(obj)
    @monitor.synchronize do
      @que.push(obj)
      @empty_cond.signal 
    end
  end

  def deq
    @monitor.synchronize do
      while @que.empty?
        @empty_cond.wait
      end
      return @que.shift
    end
  end

  def size
    @que.size
  end
end

class OurSizedQueue < OurQueue
  attr :max

  def initialize(max)
    super()
    @max = max
    @full_cond = @monitor.new_cond
  end

  def enq(obj)
    @monitor.synchronize do 
      while @que.length >= @max 
        @full_cond.wait
      end
      super(obj)
    end
  end

  def deq
    @monitor.synchronize do
      obj = super
      @full_cond.signal 
    end
    return obj
  end

  def max=(max)
    @monitor.synchronize do
      @max = max
      @full_cond.broadcast
    end
  end
end

# Еще один вариант синхронизации потоков (двухфазную блокировку со счетчиком) предлагает библиотека 
# sync.rb. В ней определен модуль Sync_m, который можно применять вместе с ключевыми словами include и
# extend (как и Mutex_m). Этот модуль содержит методы sync_locked?, sync_shared?, sync_exclusive?,
# sync_lock, sync_unlock и sync_try_lock.

# Таймаут при выполении операций
# Часто встречается ситуация, когда на выполнение операции отводится определенное максимальное время.
# Подобная возможность очень полезна, в частности, в сетевых приложениях, где ответ от сервера может и не прийти.
# Библиотека timeout.rb предлагает решение этой проблемы на основе потоков. С методом timeout ассоциирован выполняемый блок.
# Если истечет заданное число секунд, метод возбуждает исключение Timeout::Error, которое можно перехватить с помощью rescue
require 'timeout'

flag = false 
answer = nil

begin
  timeout(5) do
    puts "Хочу печенье!"
    answer = gets.chomp
    flag = true
  end
rescue Timeout::Error
  flag = false 
end

if flag 
  if answer == "cookie"
    puts "Спасибо! Хрум, хрум ..."
  else
    puts "Это же не печенье!"
    exit
  end
else
  puts "Эй, слишком медленно!"
  exit
end

puts "До встречи..."

# Но у таймаутов в Ruby есть два подвоха. Во-первых, они не являются потокобезопасными. Таймаут реализован следующим 
# образом: создать новый поток, который следит за завершением текущего, и принудительно снять текущий поток, если он не
# завершится в течение указанного времени. Но в разделе выше мы уже говорили, что принудительное снятие потоков не является
# потокобезопасной операцией, поскольку может оставить программы в неопределенном состоянии.
# Чтобы добиться безопасного эффекта таймаута, нужно написать обрабатывающий поток таким образом, чтобы он периодически # проверял, не пора ли завершаться. Тогда при завершении поток сможет выполнить необходимую очистку контролируемым образом.
# В примере ниже программа вычисляет столько простых чисел, сколько успеет за 5 секунд, и не нуждается во внешнем потоке, 
# который завершит вычисление принудительно:
require 'prime'
primes = []
generator = Prime.each 
start = Time.now 
while Time.now < (start + 5)
  10.times { primes << generator.next }
end

puts "Работала #{Time.now - start} секунд."
puts "Найдено простых чисел: #{primes.size}, последнее - #{primes.last}"

# Во время тестирования эта программа напечатала "Работала 5.005569 секунд. Найдено простых чисел:2124010, последнее - 34603729".
# На вашей машине результат может быть другим, но в любом случае видно, как можно следить за истечением времени, не
# прибегая к принудительному снятию работающего потока.
# Во-вторых, нужно помнить, что исключение Timeout::Error не перехватывается простым предложением rescue без аргументов.
# Вызов rescue без аргуменов перехватывает исключения класса StandartError и его подклассов, а Timeout::Error
# подклассом StandartError не является.
# Если в вашей программе возможны исключения таймаута, то обязательно перехватывайте исключения обоих видов. Это относится,
# в частности, к любому использованию библиотеки Net::HTTP, в которой библиотека Timeout применяется, чтобы прервать 
# обработку запросов, выполняющихся слишком долго.

# Ожидание события
# Часто один или несколько потоков следят за "внешним миром", а остальные выполняют полезную работу.
# Все примеры в этом разделе надуманные, но общий принцип они все же иллюстрируют.
# В следующем примере прикладную задачу решают три потока. Четвертый поток каждые пять секунд просыпается,
# проверяет глобальную переменную $flag и, когда видит, что флаг поднят, пробуждает еще два потока.
# Это освобождает три рабочих потока от необходимости напрямую общаться с двумя другими и, возможно, от
# многочисленных попыток разбудить их.
$flag = false 
work1 = Thread.new { job1() }
work2 = Thread.new { job2() }
work3 = Thread.new { job3() }

thread4 = Thread.new { Thread.stop; job4() }
thread5 = Thread.new { Thread.stop; job5() }

watcher = Thread.new do 
  loop do
    sleep 1 
    if $flag
      thread4.wakeup 
      thread5.wakeup 
      Thread.exit
    end
  end
end
# Если в какой-то момент выполнения любого из методов job, переменная $flag станен равной true, то в течение
# одной секунды после этого потоки thread4 и thread5 гарантированно запустятся. После этого поток watcher
# завершается.
# В следующем примере мы ждем создания файла. Каждую секунду проверяется его существование, и как только
# файл появится, мы запускаем новый поток. Тем временем остальные потоки занимаются своим делом.
# На самом деле, ниже мы наблюдаем за тремя разными файлами.
def process_file(filename)
  puts "Обрабатывается файл #{filename}"
end

def waitfor(filename)
  loop do 
    if File.exist? filename 
      file_processor = Thread.new { process_file(filename)}
      Thread.exit 
    else 
      sleep 1 
    end 
  end
end

waiter1 = Thread.new { waitfor("Godot") }
waiter2 = Thread.new { waiter("Guffman") }
headwaiter = Thread.new { waitfor("head") }

# Основной поток занимается другими делами...

# Есть много других ситуаций, когда поток должен ожидать внешнего события, например, в сетевых приложениях
# так бывает, когда сервер на другом конце соединения работает медленно или ненадежно.

# Параллельный поиск в коллекции
# С помощью потоков нетрудно реализовать одновременную работу над альтернативными решениями. Для иллюстрации
# напишем программу, которая ищет максимальное число в нескольких массивах с ограничением по времени.
# Метод threaded_max принимает в качестве аргументов лимит времени, а также массив числовых массивов, в
# в которых производиттся поиск. Он возвращает наибольшее число, которое сумеет найти за отведенное время.
# Чтобы как можно больше успеть, наш код не просматривает все массивы поочередно, а запускает по одному
# потоку для каждого массива:
require 'thread'

def threaded_max(interval, collections)
  threads = []

  collections.each do |col|
    threads << Thread.new do 
      me = Thread.current  
      me[:result] = col.first 
      col.each do |n|
        me[:result] = n if n > me[:result]
      end
    end
  end

  sleep(interval)

  threads.each { |t| t.kill }
  results = threads.map {|t| t[:result]}

  results.compact.max                         # Может быть nil
end

collections = [
  [1, 25, 3, 7, 42, 64, 55],
  [3, 77, 1, 2, 3, 5, 7, 9, 11, 13, 102, 67, 2, 1],
  [3, 33, 7, 44, 77, 92, 10, 11]]

  biggest =  threaded_max(0.5, collections)

# Сделаем несколько замечаний. Во-первых, для простоты мы предположили, что все массивы не пусты.
# Во-вторых, каждый поток сообщает о результате своей работы в поточно-локальной переменной :result.
# Эта переменная обновляется на каждом шаге, потому что главный поток в методе threaded_max подождет
# столько времени, сколько ему сказали, а затем убьет все рабочие потоки и вернет наибольшее число, 
# найденное к этому моменту. Наконец, теоретически threaded_max может вернуть nil: какое бы длительное
# время мы не задали, есть шанс, что потоки даже не приступят к работе к тому моменту, когда у главного
# потока истощится терпение (маловероятно, но все же возможно).
# Действительно ли использование нескольких потоков ускоряет работы? Трудно сказать. Ответ зависит от 
# операционной системы, а также от количества просматриваемых массивов.

# Параллельное рекурсивное удаление.
# Забавы ради, напишем программу. которая будет удалять дерево каталогов, причем сделаем ее параллельной.
# Идея в том, что обнаружив очередной подкаталог, мы запускаем новый поток, который будет обходить его и
# удалять содержимое. Созданные  в ходе работы программы потоки хранятся в массиве threads.
# Поскольку это локальная переменная, у каждого потока будет собственная копия массива. Раз к ней может
# может обращаться всего один поток, то синхронизировать доступ не нужно.
# Отметим также, что в блок потока передается полное имя файла fullname, чтобы не нужно было беспокоиться
# по поводу того, что поток обращается к перемменной, которую кто-то еще изменяет. Поток делает для себя
# локальную копию fn этой переменной.
# После того как обход всего каталога завершен, мы должны дождаться завершения всех созданных потоков
# и только потом удалять сам обработанный каталог:
def delete_all(dir)
  threads = []
  Dir.foreach(dir) do |e| 
    next if [".",".."].include? e                      # Пропустить . и ..
    fullname = dir + "/" + e 
    if FileTest.directory?(fullname)
      threads << Thread.new(fullname) { |fn| delete_all(fn) }
    else
      File.delete(fullname)
      puts "удален: #{fullname}"
    end
  end

  threads.each { |t| t.join }
  puts "удаляется каталог #{dir}"
  Dir.delete(dir)
end

delete_all("/tmp/stuff")
# Будет ли такая программа работать быстрее, чем ее вариант без потоков? В наших тестах получалось по-разному.
# Возможно, это зависит от операционной системы и структуры конкретного каталога - глубины, количества файлов и т.д.

# Волокна и кооперативная многозадачность
# Помимо полноценных потоков операционной системы, Ruby предоставляет еще волокна, которые можно описать
# как урезанные потоки или как блоки со сверхестественными способностями.
# С волокнами не связан поток ОС, но они могут содержать блок кода, который запоминает свое состояние, 
# может быть приостановлен и возобновлен и способен отдавать результаты. Для иллюстрации начнем с создания
# волокна методом Fiber.new:
fiber = Fiber.new do 
  x = 2
  Fiber.yield x 
  x = x * 2 
  Fiber.yield x 
  x * 2
end
# Метод Fiber.new не приводит к выполнению какого-либо кода в блоке волокна. Чтобы шестеренки закрутились,
# нужно вызвать метод resume. Вызов resume заставляет код в блоке выполняться до тех пор, пока не будет
# достигнут конец блока или не вызван метод Fiber.yield. Поскольку в нашем волокне вызов Fiber.yield
# встречается во второй строчку блока, то первый вызов resume доработает до второй строчки. Метод resume
# возвращает значение, переданное методу Fiber.yield в данном случае 2:
answer1 = fiber.resume                  # answer1 равно 2
# До сих пор все это сильно напоминает лямбда-выражения, но дальше станет интереснее. Если вызвать resume
# второй или третий раз, то волокно продолжит работу с того места, где остановились:
answer2 = fiber.resume                  # должно быть 4
answer3 = fiber.resume                  # должно быть 8
# По достижению конца блока волокно поступит так, как принято в таком случае, - вернет последнее значение.
# С учетом сказанного волокно можно рассматривать как блок с возможностью продолжения: встретив вызов
# Fiber.yield, волокно запоминает, где находится, и дает возможность продолжить работу с этого места.
# Продолжать можно до тех пор, пока не будет достигнут конец блока; если вызвать resume после этого, возникнет
# исключение FiberError.
# Как мы уже сказали, волокно можно считать блоком с возможностью продолжения. Но, можно взглянуть на него
# и как на поток, планируемый вручную. Волокно не работает более-менее непрерывно в фоновом режиме, 
# а исполняется в потоке, вызвавшем resume, пока не завершится или не встретит очередной вызов Fiber.yield.
# Другими словами, если потоки реализуют вытесняющую многозадачность, то волокна - кооперативную.
# Помимо основных методов Fiber.new и yield, можно получить дополнительный бонус, загрузив библиотеку 'fiber'
# В этом случае становится доступным метод Fiber.current, который возвращает текущий исполняемый экземпляр
# волокна, а также метод экземпляра alive?, который сообщает, живо ли еще волокно.
# Наконец, библиотека fiber наделяет каждый объект волокна методом экземпляра transfer, который позволяет
# передавать управление от одного волокна другому (чем достигается по-настоящему кооперативное поведение).
# Чтобы закрыть эту тему, перепишем пример поиска в нескольких массивах с использованием волокон:
require 'fiber'

class MaxFiber < Fiber 
  attr_accessor :result 
end

def max_by_fiber(interval, collections)
  fibers = []
  collections.each_with_index do |numbers|
    fibers << MaxFiber.new do 
      me = Fiber.current 
      me.result = numbers[0]
      numbers.each_with_index do |n, i|
        me.result = n if n > me.result
        Fiber.yield me.result if (i+1) % 3 == 0 
      end
      me.result
    end
  end

  start_time = Time.now 
  while fibers.any? &:alive? 
    break if Time.now - start_time > interval
    fibers.each { |f| puts f.resume if f.alive? }
  end

  values = fibers.map &:result
  values.compact.max || 0
end

collections = [
       [1, 25, 3, 7, 42, 64, 55],
       [3, 77],
       [3, 33, 7, 44, 77, 102, 92, 10, 11],
       [1, 2, 3, 4, 5, 6, 7, 8, 9, 77, 2, 3]]

biggest = max_by_fiber(0.5, collections)

# Поскольку мы работаем с волокнами, а не с потоками, истинного параллелизма здесь нет. Но волокна дают
# элегантный способ циклически перебирать массивы, запоминая, в каком месте каждого массива мы остановились.
# Возможность волокон приостанавливать выполнение наиболее полезна, когда необходимо сделать паузу
# перед вычислением очередного элемента. Вероятно, вы обратили внимание на сходство с работой объектов
# Enumerator, и это неудивительно, потому что перечислители на самом деле реализованы с помощью волокон.
# Методы next, take и все остальные просто вызывают метод resume ассоциированного с перечислителем волокон
# столько раз, сколько это необходимо для порождения запрошенных результатов.

# Методы system и exec
# Метод system (из модуля Kernel) эквивалентен одноименной функции из библиотеки языка C. Он выполняет
# указанную команду в отдельной оболочке.
system("date")
# Вывод направляется, как обычно, на stdout...

# Дополнительные параметры, если они заданы рассматриваются как список аргументов; в большинстве случаев
# аргументы можно задавать и в командной строке, эффект будет тот же. Разница лишь в том, то алгоритм
# расширения имени файла применяется только к первой из переданных строк.
system("rm", "/tmp/file1")
system("rm, /tmp/file2")
# Оба варианта годятся.

# А тут есть различие...
system("echo *")             # Печатается список всех файлов
system("echo", "*")          # Печатается звездочка (расширение имени файла не производится)

# Более сложные командные строки тоже работают.
system("ls -l | head -n 1")
# Отмечу, что сли требуется запомнить выведенную программой информацию (например, в переменной), то system -
# не лучший способ.
# Упомяну еще метод exec. Он ведет себя аналогично system с тем отличием, что новый процесс замещает текущий.
# Поэтому код, следующий за exec, исполняться не будет.
puts "Содержимое каталога:"
exec("ls", "-l")

puts "Эта строка никогда не исполняется!"

# Запоминание вывода программы
# Простейший способ запомнить информацию, выведенную программой, - заключить команду в обратные кавычки, например:
listing = `ls -l`                          # Одна строка будет содержать несколько строчек (lines)
now = `date`                               # "Mon Mar 12 16:50:11 CST 2001"
# Обобщенный ограничитель %x вызывает оператор обратных кавычек (который в действительности является методом
# модуля Kernel). Работает точно так же: 
listing = %x(ls -l)
now = %x(date)

# Применение %x бывает полезно, когда подлежащая исполнению строка содержит такие символы, как одиночные
# или двойные кавычки. 
# Поскольку обратные кавычки - это на самом деле метод (в некотором смысле), то его можно переопределить.
# Изменим его так, чтобы он возвращал не одну строку, а массив строк (конечно, при этом мы сохраним
# синоним старого метода, что-бы его можно было вызвать).
alias old_execute 

def `(cmd) 
  out = old_execute(cmd)           # Вызвать исходный метод обратной кавычки
  out.split("\n")                  # Вернуть массив строк!
end

entries = `ls -l /tmp`
num = entries.size                 # 95

first3lines = %x(ls -l | head -n 3)
how_many = first3lines.size        # 3

# Как видите, при таком определении изменяется также поведение ограничителя %x.
# В следующем примере мы добавили в конец команды конструкцию интерпретатора команд, которая перенаправляет
# стандартный вывод для ошибок в стандартный вывод:
alias old_execute 

def `(cmd)
  old_execute(cmd + " 2>&1")
end

entries = `ls -l /tmp/foobar`
# "/tmp/foobar: No such file or directory\n"
# Есть, конечно и много других способов изменить стандартное поведение обратных кавычек.

# Манипулирование процессами
# В этом разделе мы обсудим манипулирование процессами, хотя создание нового процесса необязательно
# связано с запуском внешней программы. Основной способ создания нового процесса - это метод fork,
# название которого в соответствии с традициями UNIX подразумевает разветвление пути исполнения
# напоминая развилку на дороге. (Отметим, однако, что Ruby не поддерживает метода fork на Windows)
# Метод fork, находящийся в модуле Kernel (а также в модуле Process), не следует путать с одноименным
# методом экземпляра в классе Thread.
# Существует два способа вызвать метод fork. Первый похож на то, как это обычно делается в UNIX, -
# вызвать и проверить возвращенное значение. Если оно равно nil, значит, мы находимся в дочернем
# процессе, в противном случае - в родительском. Родительскому процессу возвращается
# идентификатор дочернего процесса (pid).
pid = fork
if (pid == nil)
  puts "Ага, я, должно быть потомок."
  puts "Так и буду себя вести."
else
  puts "Я родитель."
  puts "Пора отказаться от детский штучек."
end
# В этом не слишком реалистичном примере выводимые строки могут чередоваться, а может случиться
# и так, что строки, выведенные родителем, появятся раньше. Но сейчас это несущественно.

# Следует также отметить, что процесс-потомок может пережить своего родителя. Для потоков в Ruby
# это не так, но системные процессы - совсем другое дело. 
# Во втором варианте вызова метод fork принимает блок. Заключенный в блок код выполняется
# в контексте дочернего процесса. Так предыдущий вариант можно было переписать следующим образом:
fork do
  puts "Ага, я, должно быть, потомок."
  puts "Так и буду себя вести."
end

puts "Я родитель."
puts "Пора отказаться от детских штучек."
# Конечно pid  по-прежнему возвращается, мы просто не показали его.

# Чтобы дождаться завершения процесса, мы можем вызвать метод wait из модуля Process.
# Он ждет завершения любого потомка и возвращает его идентификатор. Метод wait2 ведет себя 
# аналогично, только возвращает массив, содержащий pid и сдвинутый влево код завершения.
pid1 = fork { sleep 5; exit 3 }
pid2 = fork { sleep 2; exit 3 }

Process.wait           # Возвращает pid2
Process.wait2          # Возвращает [pid1, 768]
# Pid, конечно, все равно возвращается. Просто мы это не показали.
# Чтобы дождаться завершения процесса, применяется метод wait из модуля Process. Он ждет завершения
# любого потомка и возвращает его идентификатор. Метод wait2 ведет себя аналогично, но возвращает
# массив, содержащий два значения: pid и объект Process::Status, в котором хранится pid и код выхода:
pid = fork { sleep 2; exit 3 }
pid2 = fork { sleep 1; exit 3 }

pid2_again = Process.wait         # Возвращается pid2 
pid1_and_status = Process.wait2   # Возвращается [pid1, #<Process::Status exit 3>]

# Чтобы дождаться завершения конкретного потомка, пользуйтесь методами waitpid и waitpid2 соответственно.
pid3 = fork { sleep 2; exit 3 }
pid4 = fork { sleep 1; exit 3 }

sleep 3                           # Дать потомкам время завершиться

pid4_again = Process.waitpid(pid3, Process::WNOHANG)
pid3_array = Process.waitpid2(pid3, Process::WNOHANG)

# pid3_array равен [pid3, #<Process::Status exit 3>]
# Если второй параметр не задан, то вызов может блокировать программу (если такого потомка не существует).
# Второй параметр можно с помощью ИЛИ объеденить с флагом Process::WUNTACED, чтобы перехватывать
# остановленные процессы. Этот параметр системно-зависим, поэксперементируйте.
# Методу exit можно передать true, false или целое число. В соответствии с принятым в UNIX соглашением,
# код состояния 0 означает успешное завершение, а любой другой - ошибку. Поэтму при передаче true
# процесс завершится с кодом состояния 0, а при передаче false - с кодом состояния 1.
# Целое число интерпретируется как сам код состояния.
# Метод exit! немедленно завершает процесс (не вызывая зарегистрированных обработчиков). 
# Если задан целочисленный аргумент, то он возвращает в качестве кода завершения, по умолчанию
# подразумевается значение 1 (не 0).
pid1 = fork { exit! }             # Вернуть код завершения -1
pid2 = fork { exit! 0 }           # Вернуть код завершения 0

# Методы pid и ppid возвращают соответственно идентификатор текущего и родительского процессов.
proc1 = Process.pid 
fork do 
  if Process.ppid == proc1 
    puts "proc1 - мой родитель"                  # Печатается это сообщение
  else
    puts "Что происходит?"
  end 
end

# Метод kill служит для отправки процессу сигнала, как это понимается в UNIX.
# Первый параметр может быть целым числом, именем POSIX-сигнала с префиксом SIG или именем
# сигнала без префикса. Второй параметр - идентификатор процесса-получателя; если он равен нулю,
# подразумевается текущий процесс.
Process.kill(1,pid1)                     # Послать сигнал 1 процессу pid1
Process.kill("HUP",pid2)                 # Послать SIGHUP процессу pid2
Process.kill("SIGHUP",pid2)              # Послать SIGHUP процессу pid3
Process.kill("SIGHUP",0)                 # Послать SIGHUP самому себе
# Для обработки сигналов применяется метод Kernel.trap. Обычно он принимает номер или имя
# сигнала и подлежащий выполнению блок.
trap(1) do 
  puts "ОЙ!"
  puts "Перехвачен сигнал 1"
end

Process.kill(1,0)                        # Послать самому себе

# О применениях метода trap в более сложных ситуациях читайте в документации по Ruby и UNIX.
# В модуле Process есть также методы для опроса и установки таких атрибутов процесса, как
# как идентификатор пользователя, действующий идентификатор пользователя, приоритет и т.д.

# Стандартный ввод и вывод.
# Мы уже видели как работают методы IO.popen и IO.pipe, но существует еще небольшая библиотека,
# которая иногда бывает удобна.
# В библиотеке Open3.rb есть метод popen3, который возвращает массив из трех объектов IO.
# Они соответствуют стандартному вводу, стандартному выводу и стандартному выводу для ошибок
# того процесса, который был запущен методом popen3. Вот пример:
require "open3"

filenames = %w[ file1 file2 this that another one_more ]
output, errout = [], []

Open3.popen3("xargs", "ls" "-l") do |inp, out, err|
  filenames.each { |f| inp.puts f }                  # Писать в stdin процесса
  inp.close                                          # Закрывать обязательно!

  output = out.readlines                             # Читать из stdout
  errout = err.readlines                             # Читать также из stderr
end

puts "Послано #{filenames.size} строк входных данных."
puts "Получено #{output.size} строк из stdout"
puts "и #{errout.size} строк из stderr."

# В этом искусственном примере мы выполняем команду ls -l для каждого из заданных имен 
# файлов и по отдельности перехватываем стандартный вывод и стандартный вывод для ошибок.
# Отметим, что вызов close необходим, чтобы порожденный процесс увидел конец файла.
# Также отметим. что в библиотеке Open3 используется метод fork, не неализованный на платформе
# Windows; для этой платформы придется пользоваться библиотекой win-open3.

# Константа ARGV
# Глобальная константа ARGV представляет список аргументов, переданных в командной строке.
# По сути дела, это массив.
n = ARGV.size
argstr = '"' + ARGV*"," + '"'
puts "Мне бло передано аргументов: #{n}..."
puts "Вот они: #{argstr}"
puts "Заметьте, что ARGV[0] = #{ARGV[0]}"
# Если запустить эту программу с аргументами red green blue, то она напечатает:
мне было передано аргументов: 3...
Вот они: "red, green, blue"
Заметьте, что ARGV[0] = red
# В некоторых языках передается также количество аргументов, но в Ruby это ни к чему, так
# как эта информация - часть массива.

# Константа ARGF
# Глобальная константа ARGF представляет псевдофайл, получающийся в результате конкантенации
# всех имен файлов, заданных в командной строке. Во многих отношениях она ведет себя так же,
# как объект IO.
# Когда в программе встречается "голый" метод ввода (без указания вызывающего объекта),
# обычно имеется в виду метод, подмешанный из модуля Kernel (например, gets и readlines).
# Если в командной строке не задано ни одного файла, то по умолчанию источником ввода является
# объект STDIN. Но, если файлы заданы, то данные читаются из них. Понятно, что конец файла 
# достигается в конце последнего из указанных файлов.
# Если хотите, можете обращаться к ARGF явно:
# Скопировать все файлы на stdout
puts ARGF.readlines
# Быть может, вопреки ожиданиям, признак конца файла устанавливается после каждого файла. 
# Так, предыдущий код выведет все файлы, а следующий - только первый файл:
puts ARGF.gets until ARGF.eof?
# Является ли это ошибкой или нет, предоставим судить вам. Впрочем, сюрпризы могут быть и 
# приятными. Входные данные - это не просто поток байтов, мы можем применять к ARGF операции
# seek и rewind, как если бы то был "настоящий файл".
# С константой ARGF ассоциирован метода file, он возвращает объект IO, соответствующий файлу
# обрабатываемому в данный момент. Естественно, возвращааемое значение изменяется по мере
# перехода от одного файла к другому.
# А если мы не хотим интерпретировать имена аргументов в командной строке как имена файлов? 
# Тогда не надо обращаться к методам ввода без указания вызывающего объекта. Если вы хотите
# читать из стандартного ввода, укажите в качестве такого объекта STDIN, и все будет работать правильно.

# Разбор флагов в командной строке
# История библиотек для разбора командной строки в Ruby имеет давние традиции, сегодня
# для этой цели используется библиотека OptionParser. По существу, это предметно-ориентированный
# язык (DSL), описывающий, как следует разбирать аргументы программы.
# Пожалуй, лучше всего это объяснить на примере. Пусть имеется программа с такими флагами: 
# -h, или -help для печати справки, -f, или -file для задания имени файла и -l, или -lines
# для прекращения печати после вывода заданного числа строк (по умолчанию 100). Начать можно было так:
require 'optparse'

args = {lines: 100}

OptionParser.new do |opts|
  opts.banner = "Порядок вызова: tool [options] COMMAND"

  opts.on("-f", "-file FILE") do |file|
    args[:file] = file
  end

  opts.on("-l", "-lines [LINES]", Integer,
     "Сколько строк выводить (по умолчанию 100)"
     ) do |lines|
        args[:lines] = lines
     end

     opts.on_tail("-h", "-help", "Показать эту справку") do 
       puts opts
       exit
     end

    end.parse!

    p args 
    p ARGV.first

   # Если сохранить этот код в файле tool.rb и выполнить его, то будет напечатано то, что
   # и следовало ожидать:
   $ ruby tool.rb -h 
   Порядок вызова: tool [options] COMMAND 
            -f, -file FILE
            -l, -lines [LINES]    Сколько строк выводить (по умолчанию 100)
            -h, -help             Показать эту справку

  $ ruby tool.rb -file book.txt 
  {:lines=>100, :file=>"book.txt"}
  []

  $ ruby tool.rb -f book.txt -lines 10 print 
  {:lines=>10, :file=>"book.txt"}
  ["print"]
  
  # Как видно из этого примера, использование OptionParser сводится главным образом к созданию
  # объекта, и большая часть работы происходит в методе on. Идея в том, что каждый вызов on
  # описывает один распознаваемый анализатором флаг. Методу on нужно сообщить как минимум две вещи.
  # Во-первых, задается имя флага - короткое (например, -f) или длинное (например, -file).
  # Если во второй строке имя аргумента заключено в квадратные скобки, то OptionParser понимает, 
  # что аргумент необязателен и может быть опущен.
  # На примере параметра lines мы видим, что можно задать тип и описание флага. Тогда его 
  # строковое представление, заданное в командной строке, будет преобразовано в указанный тип,
  # а описание напечатано в справке.
  # Во-вторых, необходимо задать блок кода, который анализатор выполнит, распознав соответствующий флаг.
  # В этом блоке можно сделать что-то непосредственно, как в случае флага -h, а можно просто
  # сохранить данные на будущее, как в случае флагов -file и -lines.
  # В конечном итоге вызывается метод parse!, и анализатор разбирает содержимое ARGV, удаляет
  # из него аргументы, которые распознал как флаги, и выполняет для них блоки. После этого
  # в хэше args будут находиться переданные программе флаги, а в массиве ARGV останутся только
  # нераспознанные аргументы.
  # Есть немало gem-пакетов, предлагающих другие подходы к разбору командной строки. Можете
  # взять highline, slop, cocaine, thor или любую другую библиотеку, отвечающую вашим целям.

  # Использование библиотеки Shell для перенаправления ввода-вывода.
  # В классе Shell для создания объектов есть два метода: new и cd. Первый создает объект,
  # ассоциированный с текущим каталогом, второй - объект, для которого рабочим будет указанный каталог.
  require "shell"

  sh1 = Shell.new                    # Работать в текущем каталоге
  sh2 = Shell.cd("/tmp/hal")         # Работать в каталоге /tmp/hal
  
  # В библиотеке Shell определено несколько встроенных команд (например, echo, cat и tee)
  # в виде методов. Они всегда возвращают объекты класса Filter (как и определяемые пользователем
  # команды, с которыми мы скоре познакомимся).
  # Класс Filter понимает, что такое перенаправление ввода-вывода. В нем определены методы 
  # (или операторы) <,> и |, которые ведут себя примерно так, как мы ожидаем по многолетнему
  # опыту написания shell-скриптов.
  # Если методу перенаправления передать в качестве параметра строку, то она будет считаться
  # именем файла. Если же параметром является объект IO, то он используется для операций
  # ввода-вывода. Примеры:
  sh = Shell.new
  
  # Вывести файл motd на stdout
  sh.cat("/etc/motd") > STDOUT

  # Напечатать его еще раз
  (sh.cat < "/etc/motd") > STDOUT
  (sh.echo "Это тест") > "myfile.txt"

  # Добавить строку в конец файла /etc/motd
  sh.echo("Hello, world!") >> "/etc/motd"
  
  # Вывести два файла на stdout и продублировать (tee) вывод в третий файл
  (sh.cat "file1" "file2") | (sh.tee "file3") > STDOUT
  # Отметим, что у оператора > высокий приоритет. Скобки, которые вы видите в этом примере,
  # в большинстве случаев обязательны. Вот два примера правильного использования и один неправильный:

# Интерпретатор Ruby понимает такую конструкцию...
sh.cat("myfile.txt") > STDOUT

# ...и такую тоже.
(sh.cat "myfile.txt") > STDOUT

# TypeError! (ошибка связана с приоритетами)
sh.cat "myfile.txt" > STDOUT

# Отметим еще, что можно "инсталлировать" системные команды по своему выбору. Для этого служит
# метод def_system_command. Ниже определяются два метода: ls и ll, которые выводят список файлов
# в текущем каталоге (в коротком и длинном формате).
# Имя метода совпадает с именем команды...
# необходим только один параметр
Shell.def_system_command "ls"

# А здесь должно быть два параметра
Shell.def_system_command "ll", "ls -l"

sh = Shell.new
sh.ls > STDOUT       # Короткий формат
sh.ll > STDOUT       # Длинный формат
# Вы, наверное, обратили внимание на то, что в большинстве случаев мы явно отправляем вывод
# объекту STDOUT. Связано это с тем, что объект Shell автоматически вывод команд никуда не 
# направляет. Он просто ассоциирует его с объектом Filter, который уже может быть связан с файлом
# или объектом IO.

# Дополнительные замечания по поводу библиотеки Shell
# Метод transact исполняет блок в контексте объекта Shell. Таким образом, допустима следующая
# запись:
sh = Shell.new
sh.transact do 
  echo("Строка данных") > "somefile.txt"
  cat("somefile.txt", "otherfile.txt") > "thirdfile"
  cat("thirdfile") | tee("file4") > STDOUT
end

# Итератор foreach принимает в качестве параметра файл или каталог. Если это файл, то он
# перебирает все его строки, а если каталог - все имена файлов в нем.
sh = Shell.new 

# Напечатать все строки файла /tmp/foo
sh.foreach("/tmp/foo") {|l| puts l}

# Вывести список файлов в каталоге /tmp
sh.foreach("/tmp") {|f| puts f}

# Метод pushdir запоминает текущий каталог, а метод popdir делает последний запомненный 
# каталог текущим. У них есть синонимы pushd и popd. Метод pwd возвращает текущий рабочий
# каталог, его синонимы - getwd, cwd и dir.
sh = Shell.cd "/home"

puts sh.pwd        # /home
sh.pushd "/tmp"
puts sh.pwd        # /tmp

sh.popd 
puts sh.pwd        # /home 

# Для удобства в класс Shell импортируются методы из различных источников, в том числе из класса
# File, модуля FileTest и библиотеки ftools.rb. Это избавляет от необходимости выполнять 
# require, include, создавать объекты, квалифицировать вызовы методов и т.д.
sh = Shell.new 
flag1 = sh.exist? "myfile"           # Проверить существование файла
sh.delete "somefile"                 # Удалить файл
sh.move "/tmp/foo", "/tmp/bar"       # Переместить файл
# У библиотеки Shell есть и другие возможности, которые мы здесь не рассматриваем. 

# Чтение и установка переменных окружения
# Глобальная константа ENV - это хэш, с помощью которого можно читать и изменять переменные окружения.
# В примере ниже мы читаем значение переменной PATH (В Windows вместо двоеточия нужно употреблять
# точку с запятой):
mypath = ENV["PATH"]
# А теперь получим массив...
dirs = mypath.split(":")

# А вот пример установки переменной. Новый процесс мы создали, чтобы проиллюстрировать две вещи.
# Во-первых, дочерний процесс наследует переменные окружения от своего родителя. Во-вторых, значение
# переменной окружения, установленное в дочернем процессе, родителю не видно.
ENV["alpha"] = "123"
ENV["beta"] = "456"
puts "Родитель: alpha = #{ENV['alpha']}"
puts "Родитель: beta = #{ENV['beta']}"

fork do # Код потомка...
  x = ENV["alpha"]
  ENV["beta"] = "789"
  y = ENV["beta"]
  puts " Потомок: alpha = #{x}"
  puts " Потомок: beta = #{y}"
end

Process.wait
a = ENV["alpha"]
b = ENV["beta"]
puts "Родитель: alpha = #{a}"
puts "Родитель: beta = #{b}"

# Программа выводит следующие строки:
Родитель: alpha = 123
Родитель: beta = 456 
 Потомок: alpha = 123
 Потомок: beta = 789
Родитель: alpha = 123
Родитель: beta = 456
# Это следствие того факта, что родитель ничего не знает о переменных окружения своих потомков.
# Поскольку программа на Ruby обычно исполняется в подоболочке, то после ее завершения все сделанные
# изменения переменных окружения не будут видны в текущей оболочке.

# Хранение переменных окружения в виде массива или хэша.
# Важно понимать, что объект ENV - не настоящий хэш, а лишь выглядит как таковой. Например, мы не
# можем вызвать для него метод invert; будет возбуждено исключение NameError, поскольку такого
# метода не существует. Причина такой реализации в том, что существует тесная связь между объектом
# ENV и операционной системой; любое изменение хранящихся в нем значений отражается на состоянии
# ОС, а такое поведение с помощью простого хэша не смоделируешь.
# Однако имеется метод to_hash, который вернет настоящий хэш, отражающий текущее состояние:
envhash = ENV.to_hash
val2var - envhash.invert
# Получив такой хэш, мы можем преобразовать его к любому другому виду(например, в массив):
envarr = ENV.to_hash.to_a
# Обратное присваивание объекту ENV недопустимо, но, при необходимости можно пойти обходным путем:
envhash = ENV.to_hash 
# Выполняем произвольные операции... и записываем обратно в ENV.
envhash.each { |k, v| ENV[k] = v }

# Несколько слов о текстовых фильтрах
# Многие инструменты, которыми мы постоянно пользуемся (как поставляемые производителем, так и разрабатываемые
# собственными силами), - просто текстовые фильтры. Иными словами, они принимают на входе текст, 
# каким-то образом преобразуют его и выводят. Классическими примерами текстовых фильтров в UNIX
# служат, в частности, программы sort и unic.
# Иногда файл настолько мал, что целиком помещается в памяти. В этом случае возможны такие виды обработки,
# которые по-другому было бы сложно реализовать.
lines = File.open(filename) { |f| f.readlines }
# Какие-то операции...
lines.each { |x| puts x }
# Бывает, что нужно обрабатывать файл построчно.
File.open(filename) do |file|
  file.each_line do |line|
    # Какие-то операции...
    puts line
  end
end
# Наконец, не забывайте, что все имена файлов, указанные в командной строке, автоматически собираются
# в объект ARGF, представляющий конкатенацию всех выходных данных. Мы можем вызывать, к примеру, метод
# ARGF.readlines, как если бы ARGF был объектом класса IO. Вся выходная информация будет, как обычно,
# направлена на стандартный вывод.

# Копирование дерева каталогов (с символическими ссылками)
# Пусть нужно скопировать целое дерево каталогов в новое место. Сделать это можно по-разному, но если 
# в дереве есть символические ссылки, задача усложняется. Ниже приведено рекурсивное решение. Оно достаточно
# дружелюбно - контролирует входные данные и выводит информацию о порнядке запуска.
require "fileutils"

def recurse(src, dst)
  Dir.mkdir(dst)
  Dir.foreach(src) do |e| 
    # Пропустить . и ..
    next if [".", ".."].include? e 
    fullname = src + "/" + e  
    newname = fullname.sub(Regexp.new(Regexp.escape(src)),dst)
    if File.directory?(fullname)
      recurse(fullname, newname)
    elsif File.symlink?(fullname)
      linkname = `ls -l #{fullname}`.sub(/.* -> /,"").chomp 
      newlink = linkname.dup 
      n = newlink.index($oldname)
      next if n == nil 
      n2 = n + $oldname.length - 1
      newlink[n..n2] = $newname 
      newlink.sub!(/\/\//,"/")
      # newlink = linkname.sub(Regexp.new(Regexp.escape(src)),dst)
        File.symlink(newlink, newname)
    elsif File.file?(fullname)
      FileUtils.copy(fullname, newname)
    else
      puts "??? : #{fullname}"
    end
  end
end
   
# "Главная программа"

if ARGV.size != 2
  puts "Порядок вызова: copytree oldname newname"
  exit 
end

oldname = ARGV[0]
newname = ARGV[1]

if !File.directory?(oldname)
  puts "Ошибка: первый параметр должен быть именем существующего каталога."
  exit 
end

if File.exist?(newname)
  puts "Ошибка: #{newname} уже существует."
  exit
end

oldname = File.expand_path(oldname)
newname = File.expand_path(newname)

$oldname=oldname
$newname=newname 

recurse(oldname, newname)
# В современных вариантах UNIX, например Mac OS X, команда cp -R сохраняет символические ссылки, но в 
# более старых это не так. Программа показанная выше была написана для решения этой практической задачи.

# Удаление файлов по времени модификации и другим критериям.
# Предположим, мы хотим удалить самые старые файлы из какого-то каталога. В нем могут, к примеру,
# храниться временные файлы, журналы, кэш браузера и т.п.
# Представленная ниже небольшая программа удаляет файлы, которые в последний раз модифицировались раньше
# указанного момента (заданного в виде объекта Time):
def delete_older(dir, time)
  Dir.chdir(dir) do 
    Dir.foreach(".") do |entry|
      # Каталоги не обрабатываются
      next if File.stat(entry).directory?
      # Используем время модификации
      if File.mtime(entry) < time 
        File.unlink(entry)
      end
    end
  end
end

delete_older("/tmp", Time.local(2001,3,29,18,38,0)
# Неплохо, но можно обобщить. Создадим метод delete_if, который принимает блок,
# возвращающий значение true или false. И будем удалять те и только те файлы, которые
# удовлетворяют заданному критерию.
def delete_if(dir)
  Dir.chdir(dir) do 
    Dir.foreach(".") do |entry| 
      # Каталоги не обрабатываются
      next if File.stat(entry).directory? 
      if yield entry 
        File.unlink(entry)
      end
    end
  end
end

# Удалить файлы длиннее 3000 байтов
delete_if("/tmp") { |f| File.size(f) > 3000 }

# Удалить файлы с расширениями LOG и BAK 
delete_if("/tmp") { |f| f =~ /(log|bak)$/i }


# Вычисление свободного места на диске
# Пусть нужно узнать, сколько байтов свободно на некотором устройстве. В следующем прмере
# это делается по-простому, путем запуска системной утилиты:
def freespace(device=".") 
  lines = %x(df -k #{device}).split("\n")
  n = (lines.last.split[3].to_f / 1024 / 1024).round(2)
end

puts freespace("/")                # 48.7

# Для Windows имеется более элегантное решение (предложено Дэниэлем Бергером):
require 'Win32API'

GetDiskFreeSpaceEx = Win32API.new('kernel32', 'GetDiskFreeSpaceEx',
                                  'PPPP', 'I')

def freespace(dir=".")
  total_bytes = [0].pack('Q')
  total_free = [0].pack('Q')
  GetDiskFreeSpaceEx.call(dir, 0, total_bytes, total_free)
  
  total_bytes = total_bytes.unpack('Q').first
  total_free = total_free.unpack('Q').first
end

puts freespace("C:")            # 5340389376

# Работает ли Ruby в интерактивном режиме?
# Чтобы узнать, работает ли программа в интерактивном режиме, нужно проверить стандартный
# ввод. Метод isatty? возвращает true, если устройство интерактивное, а не диск или сокет.
if STDIN.isatty?
  puts "Привет! Я вижу, вы печатаете"
  puts "на клавиатуре."
else
  puts "Входные данные поступают не с клавиатуры."
end

# Подача входных данных Ruby по конвейеру
# Поскольку интерпретатор Ruby - это однопроходный транслятор, то можно подать ему на вход
# некий код и выполнить его. Это может оказаться полезным, когда обстоятельства вынуждают
# вас работать на традиционном скриптовом языке типа bash, но для каких то сложных задач
# вы хотите применить Ruby.
# Ниже представлен bash-скрипт, который вызывает Ruby (посредством вложенного документа)
# для вычисления интервала в секундах между двумя моментами времени. Ruby-программа
# печатает на стандартный вывод одно значение, которое перехватывается вызывающим скриптом.
# Для вычисления разницы в секундах между моментами времени bash вызывает Ruby...

export time1 = "2007-04-02 15:56:12"
export time2 = "2007-12-08 12:03:19"

cat <<EOF | ruby 
require "time"

time1 = ENV["time1"]
time2 = ENV["time2"]

t1 = Time.parse(time1)
t2 = Time.parse(time2)

diff = t2 - t1

puts diff
EOF

echo "Прошло секунд = " $elapsed

# В данном случае оба исходных значения передаются в виде переменных окружения (которые
# необходимо экспортировать). Строки, читающие эти значения, можно было бы записать так:
time1="$time1"             # Включить переменные оболочки непосредственно в строку
time2="$time2"
# Но возникающие при этом проблемы очевидны. Очень трудно понять, имеется ли в виду переменная bash
# или глобальная переменная Ruby. Возможна также путаница при экранировании и расстановке кавычек.

# Флаг -e позволяет создавать однострочные Ruby-скрипты. Вот пример обращения строки:
#!/usr/bin/bash
string="Francis Bacon"
reversed=$(ruby -e "puts `$string'.reverse")
echo $reversed   # "nocaB sicnarF"

# На самом деле, в Ruby предусмотрено несколько средств, удобных для написания однострочных скриптов. 
# Чтобы автоматически выполнять указанный код для каждой строки входных данных, используется флаг -n.
# Следующий код инвертирует все поданные на вход строки:
$ echo -e "Knowledge/nis/npower/n" | ruby -ne print $_.reverse
egdelwonK
si
rewop 

# Чтобы еще упростить жизнь, имеется флаг -p, который работает, как -n, но вдобавок после обработки
# каждой строки включает предложение print:
$ echo -e "France\nis\nBacon\n" ruby -pe $_.reverse!
ecnarF
si 
nocaB
# Знатоки UNIX заметят, что awk использовался подобным образом с незапамятных времен.

# Определение текущей платформы или операционной системы.
# Если программа хочет знать, в какой операционной системе исполняется, то может опросить ключ 'host_os'
# в глобальном хэше RbConfig::CONFIG. В ответ будет возвращена загадочная строка (что-то вроде darwin13.3.0,
# sygwin или solaris2), содержащая информацию о платформе, для которой был собран интерпретатор Ruby.
# Ruby работает в основном в системах Mac OS X (Darwin), вариантах UNIX вроде Linux и Solaris или 
# Windows (XP, Vista, 7, 8). Поэтому различить платформы можно с помощью очень простого регулярного выражения:
def os_family
  case RbConfig::CONFIG['host_os']
  when /(mingw|mswin|windows)/i
    "windows"
  when /cygwin/i
    "cygwin"
  when /(darwin|mac os)/i
    "osx"
  when /(linux|bsd|aix|solaris)/i
    "unix"
  end
end
# Конечно, это весьма неуклюжий способ определения ОС. Даже если вы правильно определите семейство ОС, 
# отсюда еще не следует, что нужная вам функциональность имеется (или отсутствует).

# Модуль Etc
# Модуль Etc получает различную информацию из файлов /etc/passwd и /etc/group.
# Метод getlogin возвращает имя пользователя, от имени которого запущена программа.
# Если он завершается неудачно, может помочь метод getpwuid (принимающий в качестве
# необязательного параметра идентификатор пользователя uid).
require 'etc'

myself = Etc.getlogin                    # Это я!
root_name = Etc.getpwuid(0).name         # Имя суперпользователя

# Без параметров getpwuid вызывает
# getuid ...
me2 = Etc.getpwuid.name                  # Это снова я!
# Метод getpwnam возвращает структуру passwd, которая содержит поля name, dir (начальный
# каталог), shell (начальный интерпретатор команд) и другие.
rootshell = getpwnam("root").shell       # /sbin/sh
# Методы getgrgid  и getgrnam ведут себя аналогично, но по отношению к группам.
# Они возвращают структуру group, содержащую имя группы и т.д.
# Итератор passwd обходит все записи в файле /etc/passwd.
# Запись передается в блок в виде структуры passwd.
require 'etc'

all_users = []
passwd { |entry| all_users << entry.name }
# Имеется также итератор group для обхода записей в файле /etc/group.

# Разбор JSON
# Формат JSON (JavaScript Object Notation) проектировался, чтобы в понятном человеку виде, допускающем
# массивы, хэши, числа и строки, сериализовать данные в виде простого текста для обмена между программами
# написанными на любом языке. Созданный в противовес многословностии XML, формат JSON, с одной стороны, 
# гораздо лаконичнее, если измерять в терминах количества знаков, а с другой, беднее в плане
# множества поддерживаемых типов.
# В этом разделе мы поговорим о том, как разбирать данные в этом формате и манипулировать ими. Источником
# таких данных может быть, например, API какого-то сайта. Но, сначала рассмотрим преобразование
# строки или файла, содержащего JSON-данные:
require 'json'
 
data = JSON.parse('{"students": {
    {"name": "Alice", "grade": 4},
    {"name": Bob, "grade": 3}
}}')
p data["students"].first.values_at("name", "grade")
# ["Alice", 4]
# То что в JSON называется "объектом", почти точно соответствует хэшу в Ruby. Кроме того, в JSON
# поддерживаются еще несколько хорошо знакомых типов: массивы, строки и числа. Все данные в этом 
# формате представлены в кодировке UTF-8. Помимо вышеперечисленных, можно еще представить значения
# true, false и null (соответствует nil в Ruby).

# Обход JSON-данных
# После того как JSON-данные разобраны, можно обойти образовавшиеся вложенные хэши и массивы и 
# извлечь из них нужные данные. Для иллюстрации возьмем данные, которые возвращает открытый API сайта GitHub:
require 'json'
require 'open-uri'
require 'pp'

json = open("https://api.github.com/repos/ruby/ruby/contributors")
users = JSON.parse(json)

pp users.first
# {"login"=>"nobu",
#  "id"=>16700,
#  "url"=>"https://api.github.com/users/nobu",
#  "html_url"=>"https://github.com/nobu",
#  [...прочие атрибуты...],
#  "type"=>"User",
#  "site_admin"=>false,
#  "contributions"=>9850}

users.sort_by! { |u| -u["contributions"] }
puts users[0...10].map{ |u| u["login"] }.join(", ")
# nobu, akr, nurse, unak, eban kol, drbrain, knu, kosaki, mame

# Здесь мы воспользовались библиотекой open-uri. Она позволяет использовать метод open для URI - во многом также
# как для обычного файла.
# С помощью open-uri мы скачиваем строку, которая содержит JSON-массив всех, кто принимает участие в разработке
# основного интерпретатора Ruby. Разбор JSON-данных возвращает массив хэшей, в каждом из которых находится информация
# об одном авторе. Среди ключей этого хэша мы видим, в частности: login, id, url и contributions.
# Затем мы с помощью библиотеки красивой печати "prettyprint" распечатываем хэш атрибутов для первого автора (pp печатает
# все атрибуты, но мы для краткости часть из них опустили). Далее этот список сортируется в порядке убывания количества
# вкладов автора, т.е. первым будет хэш автора, сделавшего больше всех записей в репозиторий исходного кода.
# Наконец, из отсортированных таким образом хэшей с информацией об авторах извлекаются только логины и распечатываются
# через запятую.
# Реальные приложения обычно похожи на этот пример. Мы пишем код, для получения данных из источника, разбираем их,
# представляя в виде хэша или массива Ruby, а затем ищем в нем элементы, содержащие интересующие нас данные.

# Разбор новостной ленты
# Рассмотрим обработку документов в форматах RSS и Atom с помощью стандартной библиотеки Ruby rss,
# которая прозрачно поддерживает не только ввсе три версии RSS, но и Atom. В примере ниже мы запрашиваем
# у представляемой НАСА службы "Астрономическая картина дня" ленту новостей, а затем печатаем заголовки всех новостей:
require 'rss'
require 'open-uri'

xml = open("http://apod.nasa.gov/apod.rss").read
feed = RSS::Parser.parse(xml, false)

puts feed.channel.description
feed.items.each_with_index do |item, i|
  puts "#{i + 1}. #{item.title.strip}"
end
# Обратите внимание, что анализатор RSS извлекает канал новостной ленты; наша программа затем печатает
# заголовок канала. Существует также список элементов (его возвращает акцессор items), который можно
# рассматривать как перечень статей. Мы получаем весь список и печатаем заголовок каждой статьи.
# Разумеется, конкретные данные день ото дня меняются, но вот что получилось у меня в результате
# запуска этой программы:
Astronomy Picture of the Day 
1. Star Trails Over Indonesia
2. Jupiter and Venus from Earth 
3. No X rays from SN 2014J 
4. Perseid in Moonlight
5. Surreal Moon 
6. Rings Around the Ring Nebula
7. Collapse in Hebes Chasma on Mars

# Прежде чем двигаться дальше, я хотел бы оказать любезность поставщикам каналов. Программами, подобными приведенной 
# выше, следует пользоваться  с осторожностью, так как они потребляют ресурсы сервера поставищика. В любом реальном
# приложении, например в агрегаторе каналов, следует прибегать к кэшированию. Вот просто пример кэширования:
unless File.exist?("apod.rss")
  File.write("apod.rss", open("http://apod.nasa.gov/apod.rss"))
end

xml = File.read("apod.rss")
# Здесь мы просто читаем ленту из файла, а если ее еще не существует, то записываем в файл. Для реализации более
# полезной схемы кэширования мы, наверное, проверяли бы дату создания кэшированного файла и вновь запрашивали бы ленту,
# если возраст файла превышает некоторый порог. Кроме того, мы использовали бы HTTP-заголовки If-Modified-Since или
# If-None-Match. Однако такая система уже выходит за рамки простого примера.
# Ленты в формате Atom разбираются таким же самым методом RSS::Parser.parse.
# Библиотека rss читает содержимое ленты и сама определяет, каким анализатором пользоваться. Единственное существенное
# различие состоит в том, что в формате Atom отсутствует атрибут channel. Вместо этого нужно искать атрибуты title
# и author в самой ленте.

-----------------------------------------------------------------
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

# Сравнение массивов
# Массивы сравниваются поэлементно, первая же пара несовпадающих элементов определяет результат для сравнения (-1 или 0 или 1)
a = [1, 2, 3, 9, 9]
b = [1, 2, 4, 1, 1]
c = a <=> b                # -1 (то есть a < b)

# Сортировка массив в помощью метода sort
words = %w(the quick brown fox)
list = words.sort     # ["brown", "fox", "quick", "the"]
# Или отсортировать на месте
words.sort!           # ["brown", "fox", "quick", "the"]

# В подобных случаях можно воспользоваться также блочной формой того же метода (если у каждого элемента есть метод to_s):
a = [1, 2, "three", "four", 5, 6]
b = a.sort { |x,y| x.to_s <=> y.to_s}
# b равно [1, 2, 5, 6, "four", "three"]

# Чтобы отсортировать массив в порядке убывания, достаточно просто изменить порядок сравнения:
x = [1, 4, 3, 5, 2]
y = x.sort { |a,b| b <=> a}         # [5, 4, 3, 2, 1]


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

# Метод reject - полная противоположность select
# Он исключает из массива элементы, для которых блоок возвращает значение true
# Имеется также вариант reject! для модификации массива "на месте":
c = [5, 8, 12, 9, 4, 30]
d = c.reject { |e| 3 % 2 == 0 }        # [5, 9]
c.reject! { |e| e % 3 == 0 }
# c равно [5, 8, 4]

# Методы min и max ищут минимальное и максимальное значение в массиве
a = %w[Eldond Galadriel Aragorn Saruman Legolas]
b = a.min                                 # "Aragorn"
c = a.max                                 # "Saruman"
d = a.min {|x,y| x.reverse <=> y.reverse} # "Elrond"
e = a.max {|x,y| x.reverse <=> y.reverse} # "Legolas"

# Чтобы найти индекс минимального или максимального элемента используется метод index
# Продолжение предыдущего примера...
i = a.index a.min    # 2
j = a.index a.max    # 3

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

# Определение порядкового номера дня в году:
t = Time.now
day = t.yday                    # 315

# Определение часового пояса
z1 = Time.gm(2000,11,10,22,5,0).zone            # "UTC"
z2 = Time.local(2000,11,10,22,5,0).zone         # "PST"

# Прибавление интервала к моменту времени
t0 = Time.now
t1 = t0 + 60       # Ровно одна минута с момента t0
t2 = t0 + 3600     # Ровно один час с момента t0
t3 = t0 + 86400    # Ровно один день с момента t0

# можно вычислить интервал между двумя моментами времени
# в результате вычитания одного объекта Time из другого получаем количество секунд:
today = Time.local(2014,11,10)
yesterday = Time.local(2014,11,9)
diff = today - yesterday                  # 86400 секунд

# Преобразование часовых поясов, в случае если заранее известна разница во времени:
mississipi = Time.local(2014,11,13,9,35)        # 9:35 am CST
calofornia = mississipi - 2*3600                # Минус два часа

time1 = mississipi.strftime("%X CST")           # 09:35:00 CST
time2 = california.strftime("%X PST")           # 07:35:00 PST

# Если нужно часто преобразовывать время из одного часового пояса в другой, то можно воспользоваться
# расширением класса Time, предоставляемое gem-пакетом ActiveSupport
require 'active_support/time'
Time.zone = -8
Time.zone.name          # "Тихоокеанское время (США и Канада)"
Time.zone.now           # Wed, 25 Jun 2014 12:20:35 PDT -07:00
Time.zone.now.in_time_zone("Hawaii")  # 09:20:36 HST -10:00
----------------------------------------------------------------------------------------
# Выборка массива по заданному критерию
# Метод detect находит не больше одного элемента. Он принимает блок (которому элементы передаются последовательно)
# и возвращает первый элемент, для которого значение блока оказывается равным true
x = [5, 8, 12, 9, 4, 30]
# найти первый элемент, кратный 6
x.detect { |e|  e % 6 == 0}           # 12
# найти первый элемент, кратный 7
x.detect { |e| e % 7 == 0}           # nil

# Метод find - синоним detect, метод find_all возвращает несколько элементов, а не один единственный,
# а select - синоним find_all
# Продолжение предыдущего примера...
x.find { |e| e % 2 == 0}           # 8
x.find_all { |e| e % 2 == 0}       # [8, 12, 4, 30]
x.select { |e| e % 2 == 0}         # [8, 12, 4, 30]

# Массивы. Объединение и пересечение (операторы | (или) и &)
a = [1, 2, 3, 4, 5]
b = [3, 4, 5, 6, 7]
c = a | b                   # [1, 2, 3, 4, 5, 6, 7]
d = a & b                   # [3, 4, 5]

# Дубликаты удаляются...
e = [1, 2, 2, 3, 4]
f = [2, 2, 3, 4, 5]
g = e & f                   # [2, 3, 4]

# Для объединения множеств можно использовать и оператор конкатенации (+),
# но он не удаляет дубликаты
# Метод (-) позволяет удалить все одинаковые элементы множеств и оставить только те, которые не повторялись
a = [1, 2, 3, 4, 5]
b = [4, 5, 6, 7]
c = a - b                 # [1, 2, 3]
# Отметим, что наличие элементов 6 и 7 не отражается на результате

# Чтобы проверить входит ли некий элемент в множество, пользуйтесь методом include? или member?
x = [1, 2, 3]
if x.include? 2
  puts "yes"              # Печатается "yes"
else
  puts "no"
end
# Еще вариант:
class Object

  def in(other)
    other.include? self
  end

end

x = [1, 2, 3]
if 2.in x 
  puts "yes"              # Печатается "yes"
else
  puts "no"
end
---------------------------------------------------------------------------------------------------------
# Рандомизация массива
# Чтобы поставить элементы массива в случайном порядке можно воспользоваться методом shuffle:
x = [1, 2, 3, 4, 5]
y = x.shuffle               # [3, 2, 4, 1, 5]
x.shuffle!                  # x равно [3, 5, 4, 1, 2]

# Выбрать случайный элемент массива можно с помощью метода sample:
x = [1, 2, 3, 4, 5]
x.sample                    # 4
x.sample(2)                 # [5, 1]

# Удаление элементов, равных nil из массива
# Метод compact (и его вариант compact! для модификации на месте) удаляет из массива элементы, равные nil, оставляя все остальные без изменения:
a = [1, 2, nil, 3, nil, 4, 5]
b = a.compact                 # [1, 2, 3, 4, 5]
a.compact!                    # a равно [1, 2, 3, 4, 5]

# Удаление заданных элементов из массива
# Чтобы удалить элемент с известным индексом, достаточно вызвать метод delete_at:
a = [10, 12, 14, 16, 18]
a.delete_at(3)                # Возвращает 16
# a равно [10, 12, 14, 18]
a.delete_at(9)                # Возвращает nil (вне диапазона)

# Все элементы с заданным значением поможет удалить метод delete
# Он возвращает значения удаленных элементов или nil, если искомый элемент не найден:
b = %w(spam spam bacon spam eggs ham spam)
b.delete("spam")                           # Возвращает "spam"
# b равно ["bacon", "eggs", "ham"]
b.delete("caviar")                         # Возвращает nil

# Метод delete принимает также блок. Это не вполне согласуется с интуицией; если объект не найден, происходит
# вычисление блока (при этом могут выполняться различные операции) и возвращается вычисленное значение.
c = ["alpha", "beta", "gamma", "delta"]
c.delete("delta") { "Nonexistent"}
# Возвращается "delta" (блок не вычисляется)
c.delete("omega") { "Nonexistent"}
# Возвращается "Nonexistent"

# Метод delete_if передает каждый элемент массива в блоок и удаляет те элементы
# для которых вычисление блока дает true
email = ["job offer", "greetings", "spam", "news items"]
# удалить слова из четырех букв
email.delete_if { |x| x.length == 4 }
# email равно ["job offers", "greetings", "news items"]

# Метод slice! получает доступ к тем же элементам, что и slice, но, помимо
# возврата их значений, еще и удаляет из массива:
x = [0, 2, 4, 6, 8, 10, 12, 14, 16]
a = x.slice!(2)                       # 4
# x равно [0, 2, 6, 8, 10, 12, 14, 16]
b = x.slice!(2, 3)                    # [6, 8, 10]
# x равно [0, 2, 12, 14, 16]
c = x.slice!(2..3)                    # [12, 14]
# x равно [0, 2, 16]

# Для удаления элементов массива можно также пользоваться методами shift и pop
x = [1, 2, 3, 4, 5]
x.pop                                 # Удалить последний элемент
# x равно [1, 2, 3, 4]
x.shift                               # Удалить первый элемент
# x равно [2, 3, 4]

# Метод reject принимает блок и формирует новый массив без тех элементов, для которых блок возвращает true:
arr = [1, 2, 3, 4, 5, 6, 7, 8]
odd = arr.reject { |x| x % 2 == 0}             # [1, 3, 5, 7]

# Наконец метод clear удаляет из массива все элементы:
x = [1, 2, 3]
x.clear
# x равно []

# Конкатенирование массивов и добавление в конец массива
# Оператор << добавляет объект в конец массива, в качестве значения он возвращает сам массив, поэтому можно объединять
# в цепочку несколько таких операций:
x = [1, 5, 9]
x << 13                  # x равно [1, 5, 9, 13]
x << 17 << 21            # x равно [1, 5, 9, 13, 17, 21]

# Аналогичную операцию выполняют методы unshift и push, которые добавляют элемент в начало и в конец массива соответственно:
x = [1, 5, 9]
x.push *[2, 6, 10]                 # x равно [1, 5, 9, 2, 6, 10]
x.unshift 3                        # x равно [3, 1, 5, 9, 2, 6, 10]

# Массивы можно конкатенировать методом concat или с помощью операторов + b +=:
x = [1, 2]
y = [3, 4]
z = [5, 6]
b = y + z                      # [3, 4, 5, 6]
b += x                         # [3, 4, 5, 6, 1, 2]
z.concat y                     # z равно [5, 6, 3, 4]

# Оператор += всегда создает новый объект. Также не забываем, что оператор << добавляет в конец новый элемент, который сам может быть массивом:
a = [1, 2]
b = [3, 4]
a += b                         # [1, 2, 3, 4]

a = [1, 2]
b = [3, 4]
a << b                         # [1, 2, [3, 4]]

a = [1, 2]
b = [3, 4]
a = a.concat(b)                # [1, 2, 3, 4]
-------------------------------------------------------------------------------------------------------------
# Обход массива делается с помощью стандартного итератора each, однако есть и другие полезные итераторы, например - reverse_each,
# который обходит массив в обратном порядке:
words = %w(Son I am able she said)
str = ""
words.reverse_each { |w| str += "#{w} "}
# str равно "said she able am I Son "

# Итератор each_with_index (подмешанный из модуля Comparable) передает в блок как сам элемент, так и его индекс:
x = ["alpha", "beta", "gamma"]
x.each_with_index do |x, i|
  puts "Элемент #{i} равен #{x}"
end
# выводится три строки

# Предположим, что нужно обойти массив в случайном порядке. Ниже представлен итератор random_each (который просто вызывает метод shuffle)
class Array

# Предполагается, что метод randomize определен

  def random_each
        self.shuffle.each { |x| yield x}
  end

end

dwarves = %w(Sleepy Dopey Happy Sneezy Grumpy Bashful Doc)
list = ""
dwarves.random_each {|x| list += "#{x} "}
# list равен:
# "Bashful Dopey Sleepy Happy Grumpy Doc Sneezy"
# (На вашей машине порядок может быть другим.)

# Часто бывает необходимо вставить разделители между элементами массива, но не перед первым и не после последнего
# Для этого предназначен метод join и оператор *
been_there = ["Veni", "vidi", "vici."]
journal = been_there.join(", ")                 # "Veni, vidi, vici."

letters = ["Phi", "Mu", "Alpha"]
musicians = letters.join(" ")                   # "Phi Mu Alpha"

people = ["Bob", "Carol", "Ted", "Alice"]
movie = people * " and "
# movie равно "Bob and Carol and Ted and Alice"

# Если необходимо последний элемент обрабатывать особым образом, например, вставить перед ним слово "and",
# то можно сделать это вручную:
list = %w[A B C D E F]
with_commas = list[0..-2] *", " + ", and " + list[-1]
# with_commas равно "A, B, C, D, E, and F"

# Чередование массивов
# Предположим, что есть два массива и надо построить из них третий, который содержит массивы из двух элементов, взятых из 
# соответствующих позиций исходных массивов. Это делает метод zip из модуля Enumerable:
a = [1, 2, 3, 4]
b = ["a", "b", "c", "d"]
c = a.zip(b)
# c равно [[1,"a"], [2,"b"], [3,"c"], [4, "d"]]

# Чтобы устранить вложенность - воспользуемся методом flatten:
d = c.flatten
# d равно [1, "a", 2, "b", 3, "c", 4, "d"]

# Если задан блок, то создаваемые подмассивы будут один за другим передаваться ему:
a.zip(b) { |x1, x2| puts x2 + "-" + x1.to_s}
# Печатается: a-1
#             b-2
#             c-3
#             d-4
# и возвращается nil

# Вычисление частоты различных значений в массиве
# Для массивов нет метода count, как для строк. Поэтому создадим свой собственный:
class Array

  def count
    each_with_object(Hash.new(0)){|x,h| h[x] += 1}
  end

end

meal = %w[spam spam eggs ham eggs spam]
items = meal.counts
# items равно {"ham" => 1, "spam" => 3, "eggs" => 2}
spams = items["spam"]                    # 3
# Обратите внимание, что метод возвращает хэш
-----------------------------------------------------------------------------------------
# Инвертирование массива для получения хэша
class Array

  def invert
    each_with_object({}).with_index{|(x,h),i| h[x] = i}
  end

end

a = ["red", "yellow", "orange"]
h = a.invert        # {"orange"=>2, "yellow"=>1, "red"=>0}
------------------------------------------------------------------------------------------
# Создание нового хэша
# Как и в случае класса Array, для создания хэша слушит специальный метод класса []
# Данные, перечисленные в квадратных скобках, образуют ассоциированные пары
# Ниже показаны шесть способов вызвать этот метод (все хэши содержат одни и те же данные)
a1 = Hash.[]("flat",3, "curved", 2)
a2 = Hash.[]("flat"=>3, "curved"=>2)
b1 = Hash["flat", 3, "curved", 2]
b2 = Hash["flat"=>3, "curved"=>2]
c1 = {"flat", 3, "curved", 2}                  # Почему то выдает ошибку, возможно устарел синтаксис
c2 = {"flat"=>3, "curved"=>2}
# Для a1, b1, c1: число элементов должно быть четным.

# Существует также альтернативный синтаксис для задания литерального хэша в частном случае, когда ключами являются символы
# Начальное двоеточие в нем опускается, а стрелка заменяется двоеточием:
h1 = {:alpha => 123, :beta => 456}
h2 = {alpha: 123, beta: 456}
h1 == h2 # true

# Имеется также метод класса new, который может принимать параметр, задающий значение по умолчанию
# Это значение не является частью хэша, оно просто возвращается вместо nil
d = Hash.new                          # Создать пустой хэш
e = Hash.new(99)                      # Создать пустой хэш
f = Hash.new("a"=>3)                  # Создать пустой хэш
e["angled"]                           # 99
e.inspect                             # "{}"
f["b"]                                # {"a"=>3} (значением по умолчанию)
                                      # является тоже хэш
f.inspect                             # "{}"

# Наконец, упомянем о методе to_h из класса Array, он преобразует произвольный массив двухэлементных массивов в хэш,
# состоящий из ключей и значений:
g = [["a", 1]].to_h  # {"a" => 1}

# Задание значения по умолчанию для хэша
# Значением по умолчанию для хэша является объект, возвращаемый вместо nil в случае, когда указанный ключ не найден
# Это полезно, если вы планируете вызывать для возвращенного значения методы, которые для nil не определены.
# Задать значение по умолчанию можно в момент создания хэша или позже с помощью метода default=
a = Hash.new("missing")                # объект по умолчанию - строка "missing"
a["hello"]                             # "missing"
a.default="nothing"
a["hello"]                             # "nothing"
a["good"] << "bye"                     # "nothingbye"
a.default                              # "nothingbye"

# В отличие от метода default, блок позволяет задать свое значение вместо каждого отсутствующего ключа.
# Типичная идиома - хэш, для которого значением по умолчанию является массив, так что элементы можно добавлять,
# не проверяя явно, что значение отсутствует, и не создавая пустой массив:
a = Hash.new{|h, key| h[key] = []}            # Значением по умолчанию является new []
a["hello"]                                    # []
a["good"] << "bye"                            # {"good" => ["bye"]}

# Имеется также специальный метод экземпляра fetch, который возбуждает исключение IndexError, если в объекте
# типа Hash нет указанного ключа. Он принимает также второй параметр, играющий роль значения по умолчанию.
# Кроме того, методу fetch можно передать необязательный блок, который выработает значение по умолчанию, если ключ
# не будет найден. Принцип здесь такой же, как при создании значений по умолчанию блоком.
a = {"flat" => 3, "curved" => 2, "angled" => 5}
a.fetch("pointed")                               # IndexError
a.fetch("curved", "na")                          # 2
a.fetch("x", "na")                               # "na"
a.fetch("flat") {|x| x.upcase }                  # 3
a.fetch("pointed") {|x| x.upcase }               # "POINTED"

# Доступ к парам ключ-значение и добавление новых пар.
# В классе Hash есть методы класса [] и []=
# Используются они почти так же, как одноименные методы в классе Array, но принимают лишь один параметр.
# В качестве параметра может выступать любой объект, а не только строка (хотя строки используются чаще всего)
a = {}
a["flat"] = 3                       # {"flat"=>3}
a.[]=("curved", 2)                  # {"flat"=>3, "curved"=>2}
a.store("angled", 5)                # {"flat"=>3, "curved"=>2, "angled"=>5}
# Метод store - просто синоним []=, оба могут принимать два аргумента, как показано в примере выше.
# Метод [] аналогичен методу fetch, но не возбуждает исключение IndexError, когда ключи отсутствует, а возвращает nil
a.fetch("flat")                     # 3
a.[]("flat")                        # 3
a["flat"]                           # 3
a["bent"]                           # nil

# Предположим, что мы не уверены, существует ли объект Hash, но хотели бы избежать очистки имеющегося хэша.
# Очевидное решение - проверить, определен ли интересующий нас объект:
a = {} unless defined? a 
a["flat"] = 3
# Но есть и другой, более идиоматический, способ:
a ||= {}
a["flat"] = 3
# Или даже так:
(a ||= {})["flat"] = 3
# Тот же вопрос можно поставить для отдельных ключей, когда новое значение следует присваивать лишь, если такого ключа еще нет:
a = Hash.new(99)
a[2]                           # 99
a                              # {}
a[2] ||= 5                     # 99
a                              # {}
b=Hash.new
b                              # {}
b[2]                           # nil
b[2] ||= 5                     # 5
b                              # {2=>5}
# Отметим, что nil может выступать и в качестве ключа, и в качестве значения:
b={}
b[2]                           # nil
b[3]=nil                           
b                              # {3=>nil}
b[2].nil?                      # true
b[3].nil?                      # true
b[nil]=5                       
b                              # {3=>nil, nil=>5}
b[nil]                         # 5
b[b[3]]                        # 5

# Удаление пар ключ-значение
# Удалить пары ключ-значение из хэша можно с помощью методов clear, delete, delete_if, reject! и shift.
# Метод clear удаляет из хэша все пары. Метод shift удаляет незаданную пару ключ-значение и возвращает ее в виде
# массива из двух элементов или nil, если никаких ключей не осталось.
a = {1=>2, 3=>4}
b = a.shift                    # [1, 2]
# a равно {3=>4}

# Метод delete удаляет конкретную пару ключ-значение. Он принимает в качестве параметра ключ и возвращает ассоциированное
# с ним значение, если такой ключ существовал (и был удален). В противном случае возвращается значение по умолчанию.
# Метод также принимает блок, который вырабатывает уникальное значение по умолчанию вместо того, чтобы возвращать ссылку на общий объект.
a = {1=>1, 2=>4, 3=>9, 4=>16}
a.delete(3)                    # 9
# a равно {1=>1, 2=>4, 4=>16}
a.delete(5)                    # в этом случае nil
a.delete(6) { "не найдено" }   # "не найдено"

# Обход хэша.
# В классе Hash имеется стандартный итератор each, а кроме него итераторы each_key, each_pair и each_value (each_pair синоним each)
{"a" => 3, "b" => 2}.each do |key, val|
  print val, "from", key, "; "             # 3 from a; 2 from b;
end
# Остальные два итератора передают в блок только ключ или только значение:
{"a" => 3, "b" => 2}.each_key do |key|
  print "key = #{key};"                    # Prints: key = a; key = b;

{"a" => 3, "b" => 2}.each_value do |value|
  print "val = #{value};"                  # Prints: val = 3; val = 2;
end
# Инвертирование хэша
# Инвертирование хэша осуществляется в Ruby тривиально с помощью метода invert:
a = {"fred"=>"555-1122", "jane"=>"555-7779"}
b = a.invert
b["555-7779"]                               # "jane"

# Поиск ключей и значений в хэше
# Определить, было ли присвоено значение некоторому ключу, позволяет метод has_key? или любой из его синонимов include?, key?, member?:
a = {"a"=>1, "b"=>2}
a.has_hey? "c"       # false
a.include? "a"       # true
a.key? 2             # false
a.member? "b"        # true
# Можно также воспользоваться методом empty?, чтобы узнать, остался ли в хэше хотя бы один ключ.
# А метод length и его синоним size позволяют узнать, сколько ключей имеется в хэше:
a.empty?             # false
a.length             # 2
# Можно подтвердить также, существует ли указанное значение.
# Для этого предназначены методы has_value? или value?:
a.has_value? 2       # true
a.value?     99      # false

# Копирование хэша в массив.
# Чтобы преобразовать весь хэш в массив, пользуйтесь методом to_a.
# Получившийся массив содержит двухэлементные массивы, содержащие пары ключ-значение:
h = {"a" => 1, "b" => 2}
h.to_a                    # [["a", 1], ["b", 2]]
# Можно также получить массив, содержащий только ключи или только значения:
h.heys                    # ["a", "b"]
h.values                  # [1, 2]
# Наконец, можно поместить в массив только значения, соответствующие заданному списку ключей. 
# Этот метод работает для хэшей примерно так же, как одноименный метод для массивов.
# (Кроме того, как и в случае массивов, метод values_at заменяет устаревшие методы indices и indexes.)
h = {1=>"one", 2=>"two", 3=>"three", 4=>"four", "cinco"=>"five"}
h.values_at(3,"cinco",4)                  # ["three", "five", "four"]
h.values_at(1, 3)                         # ["one", "three"]

# Выборка пар ключ-значение по заданному критерию
# К классу Hash подмешан модуль Enumerable, поэтому можно обращаться к методам detect(find), select(find_all), grep, min, max и reject (как и для массивов).
# Метод detect (синоним find) находит одну пару ключ-значение. Он принимает блок (которому передается по одной паре за раз) и возвращает первую пару,
# для которой вычисление блока дает true.
names = {"fred"=>"jones", "jane"=>"tucker",
         "joe"=>"tucker","mary"=>"SMITH"}
# Найти tucker
names.detect { |k, v| v == "tucker" }              # ["joe", "tucker"]
# Найти имена, записанные заглавными буквами
names.find { |k, v| v == v.upcase }                # ["mary", "SMITH"]

# Разумеется, объекты в хэше могут быть сколько угодно сложными, как и условие, проверяемое в блоке, но
# сравнение объектов разных типов может оказаться проблематичным
# Метод select (синоним find_all) возвращает все пары, удовлетворяющие условию, а не только первую:
names.select { |k, v| v == "tucker" }
# [["joe", "tucker"], ["jane", "tucker"]]
names.find_all { |k, v| k.count("r")>0}
# [["mary", "SMITH"], ["fred", "jones"]]

# Сортировка хэша
# Хэши по своей природе не упорядочены ни по ключам, ни по значениям. Чтобы отсортировать хэш, Ruby преобразует его в массив,
# а затем сортирует этот массив. Понятно, что и результатом является массив.
names = {"Jack"=>"Ruby", "Monty"=>"Python",
         "Blaise"=>"Pascal", "Minnie"=>"Perl"}
list = names.sort
# list равно:
# [["Blaise", "Pascal"], ["Jack", "Ruby"],
# ["Minnie", "Perl"], ["Monty", "Python"]]
# Ниже показано, как такой массив преобразовать обрабно в хэш:
list_hash = list.to_h

# Объединение двух хэшей
# Иногда нужно объеденить хэши. Метод merge получает два хэша и формирует из них третий, перезаписывая обнаружившиеся дубликаты:
dict = {"base" => "foundation", "pedestal" => "base"}
added = {"base" => "non_acid", "salt" => "NaCL"}
new_dict = dict.merge(added)
# {"base" => "non-acid", "pedestal" => "base", "salt" = "NaCl"}
# У метода merge есть синоним update

# Если задан блок, то он может содержать алгоритм устранения коллизий. В примере ниже, если два ключа совпадают, 
# то в объединенном хэше остается меньшее значение (по алфавиту, по числовому значению или в каком то ином смысле):
dict = {"base" => "foundation", "pedestal" => "base"}
added = {"base" => "non-acid", "salt" => "NaCL"}
new_dict = dict.merge(added) { |key,old,new| old < new ? old : new}
# {"salt" => "NaCl", "pedestal" => "base", "base" => "foundation"}
# Таким образом, при использовании блока результат может получиться не такой, как в случае, когда блок не задан.
# Имеются также методы merge! и update!, которые изменяют вызывающий объект "на месте".

# Создание хэша из массива.
# Простейший способ сделать это - прибегнуть к методу to_h массива, содержащего двухэлементные массивы.
# Можно также воспользоваться методом [] класса Hash, которому передаются либо двухэлементные массивы, либо один
# массив, содержащий четное число элементов.
pairs = [[2, 3], [4, 5], [6, 7]]
array = [2, 3, 4, 5, 6, 7]
h1 = pairs.to_h                         # {2 => 3, 4 => 5, 6 => 7}
h2 = Hash[pairs]                        # {2 => 3, 4 => 5, 6 => 7}
h3 = Hash[*array]                      # {2 => 3, 4 => 5, 6 => 7}

# Вычислениие разности и пересечения хэшей
a = {"a" => 1, "b" => 2, "z" => 3}
b = {"x" => 99, "y" => 88, "z" => 77}
intersection = a.keys & b.keys
difference = a.keys - b.keys
c = a.dup.update(b)
inter = {}
intersection.each { |k| inter[k] = c[k] }
# inter равно {"z" = 77}
diff={}
difference.each { |k| diff[k]=c[k] }
# diff равно {"a"=> 1, "b"=>2}

# Хэш как разреженная матрица
# Часто в массиве или матрице заполнена лишь небольшая часть элементов. Можно хранить их как обычно, но такое
# расходование памяти неэкономно. Хэш позволяет хранить только реально существующие значения.
# В следующем примере предполагается, что несуществующие значения о умолчанию равны нулю:
values = Hash.new(0)
values[1001] = 5
values[2010] = 7
values[9237] = 9
x = values[9237]            # 9
y = values[5005]            # 0
# Ясно, что обычный массив в таком случае содержал бы более 9000 неиспользуемых элементов, что не всегда приемлемо.
# А если нужно реализовать разреженную матрицу размерности два или более?
# В этом случае можно было бы использовать массивы в качестве ключей:
cube = Hash.new(0)
cube[[2000, 2000, 2000]] = 2
z = cube[[36, 24, 36]]      # 0
# Здесь обычная матрица содержала бы миллиарды элементов.

# Хэши обычно индексируются на основе значений ключей. При желании можно изменить подобное поведение, так чтобы
# сравнение производилось по идентификатору объекта. Метод compare_by_identity переводит хэш в этот специальный режим,
# а метод compare_by_identity? сообщает, в каком режиме находится хэш:
h1 = { "alpha" => 1, :echo => 2, 35 => 3 }
h2 = h1.dup.compare_by_identity

h1.compare_by_identity?                  # false
h2.compare_by_identity?                  # true

a1 = h1.values_at("alpha", :echo, 35)    # [1, 2, 3]
a2 = h2.values_at("alpha", :echo, 35)    # [nil, 2, 3]
# Причина продемонстрированного выше поведения, конечно же, в том, что симвоы и целые числа в Ruby являются
# непосредственными значениями (как и true, false, nil).
# Однако же для строк в кавычках создаются разные объекты с разными идентификаторами.

# Метод inject. Этот метод пришел в Ruby из языка Smalltalk. В качестве примера рассмотрим массив чисел,
# которые нужно просуммировать:
nums = [3, 5, 7, 9, 11, 13]
sum = nums.inject(0) { |x,n| x + n }
# Обратите внимание, что начальное значение аккумулятора равно 0 ("нейтральный элемент" для операци сложения).
# Затем блок получает текущее значение аккумулятора и значение текущего элемента списка.
# Действие блока заключается в прибавлении нового значения к текущей сумме. Ясно, что этот код эквивалентен следующему:
sum = 0
nums.each { |n| sum += n}
# Начальное значение аккумулятора задавать необязательно. Если оно опущено, то в качестве такового используется
# значение первого элемента, который при последующих итерациях опускается.
sum = nums.inject { |x, n| x + n}
# То же самое, что:
sum = nums[0]
nums[1..-1].each { |n| sum += n}

# Похожий пример - вычисление произведения чисел. В данном случае аккумулятору следует присвоить начальное 
# значение 1 (нейтральный элемент для операции умножения)
prod = nums.inject(1) {|x,n| x*n}
# или
prod = nums.inject {|x,n| x*n}

# В следующем немного более сложном примере мы находим самое длинное слово в списке:
words = %w[ alpha beta gamma delta epsilon eta theta ]
longest_word = words.inject do |best,w|
  w.length > best.length ? w : best
end
# возвращается значение "epsilon"

# Кванторы. Кванторы any? и all? упрощают проверку свойств коллекции. Оба квантора принимают в качестве
# параметра блок (который должен возвращать значение true или false).
nums = [1, 3, 5, 8, 9]
# Есть ли среди чисел четные?
flag1 = nums.any? {|x| x % 2 == 0}      # true

# Все ли числа четные?
flag2 = nums.all? {|x| x % 2 == 0}      # false

# Если блок не задан, то просто проверяется значение истинности каждого элемента. Иными словами, неявно добавляется блок {|x| x}.
flag1 = list.all?                       # list не содержит ни одного false или nil
flag2 = list.any?                       # list содержит хотя бы одно истинное значение
                                        # не nil и не false

# Метод partition. Если при вызове метода задан блок, то этот блок вычисляется для каждого элемента набора.
# В результате создается два массива, в первый попадают элементы, для которых блок вернул true, во второй - остальные.
# Метод возвращает массив, двумя элементами которогоо являются эти массивы.
nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]

odd_even = nums.partition { |x| x % 2 == 1 }
# [[1,3,5,7,9], [2,3,4,6,8]]

under5 = nums.partition { |x| x < 5 }
# [[1,2,3,4], [5,6,7,8,9]]

squares = nums.partition { |x| Math.sqrt(x).to_i**2 == x }
# [[1,4,9], [2,3,5,6,7,8]]

# Обход с группировкой
# Иногда желательно на каждой итерации анализировать по два, три или более элементов.
# Итератор each_slice принимает в качестве параметра число n, равное числу просматриваемых на каждой
# итерации элементов. Если не осталось достаточного количества, то размер последнего фрагмента будет меньше.
arr = [1,2,3,4,5,6,7,8,9,10]
arr.each_slice(3) do |triple|
  puts triple.join(",")
end

# Выводится:
# 1,2,3
# 4,5,6
# 7,8,9
# 10

# Имеется также итератор each_cons, который позволяет обходить набор методом "скользящего окна" заданного размера
# В таком случае фрагменты всегда будут иметь одинаковый размер.
arr = [1,2,3,4,5,6,7,8,9,10]
arr.each_cons(3) do |triple|
  puts triple.join(",")
end
# Выводится:
# 1,2,3
# 2,3,4
# 3,4,5
# 4,5,6
# 5,6,7
# 6,7,8
# 7,8,9
# 8,9,10

# Преобразование в массив или множество
# Каждая перечисляемая структура теоретически может быть тривиально преобразована в массив (методом to_a)
# Например, такое преобразование для хэша дает вложенный массив пар:
hash = {1=>2, 3=>4, 5=>6}
arr = hash.to_a                 # [[5, 6], [1, 2], [3, 4]]

# Синонимом метода to_a является метод entries.
# Если была затребована библиотека set, становится доступен метод to_set.
require 'set'
hash = {1=>2, 3=>4, 5=>6}
set = hash.to_set               # #<Set: {[1, 2], [3, 4], [5, 6]}>

# Перечислители
# Итераторный метод each не требует задания блока. Если блок не задан, то метод возвращает объект-перечислитель:
items = [1,2,3,4]
enum = items.each
enum.each { |x| puts x }        # Печатает числа по одному в строке

# 8.3.6 Пример внешнего итерирования
people = [2, "George", "Washington",
          3, "Edgar", "Allan", "Poe",
          2, "John", "Glenn",
          4, "Little", "Red", "Riding", "Hood",
          1, "Sting"]
enum = people.each
loop do
       count = enum.next         # Получить следующий элемент из массива
       count.times { print enum.next }
       puts
end

# Существует метод rewind, который "сбрасывает" внутреннее состояние, возвращаясь к началу перечисляемой последовательности:
list = [10, 20, 30, 40, 50]
enum = list.each 
puts enum.next      # 10
puts enum.next      # 20
puts.enum.next      # 30
enum.rewind
puts enum.next      # 10

# Метод with_index является простым (внутренним) итератором. Его можно использовать
# вместе с другим перечислителем, и возвращает он итератор:
list = [10, 20, 30, 40, 50]
list.each.with_index {|x,i| puts "list[#{i}] = #{x}" }
# или...
enum = list.each.with_index
loop { x, i = enum2.next; puts "list[#{i}] = #{x}" }   # такой же результат

# Дополнительные сведения о перечисляемых объектах
# Поиск и выборка
# Метод find_index ищет первый объект, равный переданному параметру и возвращает его индекс (индексация с нуля):
array = [10, 20, 30, 40, 50, 30, 20]
location = array.find_index(30)                # результат равен 2

# Методы first и last возвращают n первых или последних элементов коллекции (по умолчанию один):
array = [14, 17, 23, 25, 29, 35]
head = array.first                             # 14
tail = array.last                              # 35
front = array.first(2)                         # [14, 17]
back = array.last(3)                           # [25, 29, 35]

# Существуют также два квантора: one? и none?. Метод one? понять легко: чтобы он вернул true,
# вычисление блока кода должно дать результат true ровно один раз:
array = [1, 3, 7, 10, 15, 17, 21]
array.one? {|x| x % 2 == 0}                    # true (одно четное число)
array.one? {|x| x > 16}                        # false
[].one? {|x| true}                             # для пустого массива всегда возвращается false
# Но, вот none? не столь интуитивно очевиден. Он возвращает true, если при вычислении блока ни разу не получилось true.
array = [1, 3, 7, 10, 15, 17, 21]
array.none? {|x| x > 50}                       # true (значение блока равно false для всех элементов)
array.none? {|x| x == 1}                       # false
[].none? {|x| true}                            # true (для пустого массива блок не выполняется)
# Если блок опущен, то для каждого элемента коллекции проверяется, похож ли он на true или на false.
# Метод возвращает true, только если все проверки дают false.

# Подсчет и сравнение.
# С методом count все просто. Он может принимать параметр, блок или ничего. В последнем случае просто
# возвращается размер коллекции. Если параметром является объект, то подсчитывается количество вхождений этого 
# объекта (сравнение производится с помощью оператора ==). Если задан блок, то подсчитывается количество
# элементов коллекции, для которых блок возвращает true.
days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
days.count                         # всего 7
days.count("Saturday")             # 1 (суббота только одна!)
days.count {|x| x.length == 6}     # есть три 3 слова из шести букв
# С методами min и max мы уже встречались. Для их работы необходимо, чтобы существовал оператор <=>
# (или был включен модуль Comparable). Существует также метод minmax, который возвращает сразу
# и минимальный, и максимальный элемент массива:
days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
days.minmax     # ["Friday", "Wednesday"]
# Если для сравнения элементов нужно использовать более сложное правило, то можно прибегнуть
# к методам min_by, max_by и minmax_by, которые принимают произвольный блок кода
# (по аналогии с методом sort_by, рассмотренным выше в этой главе):
days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
days.min_by {|x| x.length}                      # "Sunday" (хотя есть и другие)
days.max_by {|x| x.length}                      # "Wednesday"
days.minmax_by {|x| x.reverse}                  # ["Friday", "Thursday"]
# В последнем примере результат содержит первый и последний элементы массива,
# буквы которых переставлены "задом наперед".

# Итерирование
# Метод cycle умеет обходить коллекцию более одного раза или даже "бесконечно"
# Параметр задает число циклов, по умолчанию подразумевается бесконечное число:
months = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]
months.cycle(2) { |x| puts m }              # всего будет 24 итерации 24
months.cycle { |x| puts x }                 # бесконечный цикл
# Метод each_with_object работает так же, как inject, но в виде дополнительной любезности возвращает
# тот же объект, который был ему передан. Так удается избежать некрасивого решения, когда приходится
# явно возвращать аккумулятор в конце блока
h = Hash.new(0)
result = [1,2,3,4].inject(h) {|acc,n| acc[n] += 1; acc}          # Некрасиво

h = Hash.new(0)
result = [1,2,3,4].each_with_object(h) do |n, acc|
  acc[n] += 1 }                                                  # Так лучше
end

# Извлечение и преобразование. 
# Существуют способы извлекать в массив только части коллекции с помощью методов take и take_while
# Они возвращают список первых элементов коллекции. В первом примере ниже рассматривается хэш, элементом
# такой коллекции является пара ключ-значение, возвращаемая в виде подмассива.
# В следующих примерах те же операции применяются к массивам:
hash = {1 => 2, 3 => 6, 4 => 8, 5 => 10, 7 => 14}
arr1 = hash.take(2)                          # [[1,2], [3,6]]
arr2 = hash.take_while {|k,v| v <= 8 }       # [[1,2], [3,6], [4,8]]
arr3 = arr1.take(1)                          # [[1,2]]
arr4 = arr2.take_while {|x| x[0] < 4 }       # [[1,2], [3,6]]
# Метод drop дополняет take. Он пропускает первые элементы коллекции и возвращает остальные.
# Существует также метод drop_while.
hash = {1 => 2, 3 => 6, 4 => 8, 5 => 10, 7 => 14}
arr1 = hash.drop(2)                          # [[4,8], [5,10], [7 => 14]]
arr2 = hash.take_while {|k,v| v <= 8 }       # [[5,10], [7 => 14]]
# Метод reduce также навеян теми же идеями, что inject. Он применяет бинарную операцию (заданную символом)
# к каждой паре элементов коллекции, но может принять также и блок. Если задано начальное значение 
# аккумулятора, оно и используется, в противном случае начальным значением будет первый элемент коллекции.
range = 3..6
# символ
range.reduce(:*)                             # 3*4*5*6 = 360
# с начальным значением, символ
range.reduce(2, :*)                          # 2*3*4*5*6 = 720
# с начальным значением, блок
range.reduce(10) {|acc, item| acc += item }  # 10+3+4+5+6 = 28
# блок
range.reduce {|acc, item| acc += item }      # 3+4+5+6 = 28
# Отметим, что задать одновременно символ бинарного оператора и блок невозможно.
# Перечисляемые объекты можно также преобразовывать в формат JSON (если затребована библиотека json)
# или в множество (если затребована библиотека set):
require 'set'
require 'json'

array = [3,4,5,6]
p array.to_set             # #<Set: {3, 4, 5, 6}>
p array.to_json            # "[3,4,5,6]"

# Ленивые перечислители.
# Метод lazy объекта Enumerable возвращает специальный объект Enumerator, который вычисляет следующий 
# элемент по мере необходимости. Это позволяет обходить группы, слишком большие для хранения в памяти,
# например, все нечетныые числа от 1 до бесконечности:
enum = (1..Float::INFINITY).each         # Enumerator
lazy = enum.lazy                         # LazyEnumerator по всем целым числам
odds = lazy.select(&:odd?)               # LazyEnumerator по нечетным числам
odds.first(5)                            # [1, 3, 5, 7, 9]
odds.next                                # 1
odds.next                                # 3
# Ленивые перечислители открывают новые возможности для экономии памяти и времени при обходе больших
# коллекций, поэтому рекомендуется внимательно ознакомиться с документацией по классу LazyEnumerator

# Множества
# Чтобы получить в свое распоряжение класс Set, достаточно написать:
require 'set'
# При этом также добавляется метод to_set в модуль Enumerable, так что любой перечисляемый объект 
# становится возможно преобразовать в множество.
# Создать новое множество нетрудно. Метод [] работает почти так же, как и для хэшей. Метод new 
# принимает в качестве необязательных параметров перечисляемый объект и блок. Если блок задан, то он
# выступает в роли "препроцессора" для списка (подобно операции map).
s1 = Set[3,4,5]                          # в математике обозначается {3,4,5}
arr = [3,4,5]
s2 = Set.new(arr)                        # то же самое
s3 = Set.new(arr) {|x| x.to_s }          # множество строк, а не чисел

# Простые операции над множествами
# Для объединения множеств служит метод union (синонимы | и +)
x = Set[1,2,3]
y = Set[3,4,5]

a = x.union(y)                            # Set[1,2,3,4,5]
b = x | y                                 # то же самое
c = x + y                                 # то же самое
# Пересечение множеств вычисляется методом intersection (синоним &):
x = Set[1,2,3]
y = Set[3,4,5]

a = x.intersection(y)                     # Set[3]
b = x & y                                 # то же самое

# В случае бинарных операторов в правой части необязательно должно быть множество.
# Подойдет любой перечисляемый объект, порождающий множество в качестве результата.
# Унарный минус обозначает разность множеств. Это было в разделе 8.1.9
diff = Set[1,2,3] - Set[3,4,5]            # Set[1,2]
# Принадлежность элемента множесту проверяют методы member? или include?, как для массивов.
# Напомним, что порядок операндов противоположен принятому в математике.
Set[1,2,3].include?(2)                    # true
Set[1,2,3].include?(4)                     # false
Set[1,2,3].member?(4)                     # false
# Чтобы проверить, является ли множество пустым, мы вызываем метод empty?, как и в случае массивов.
# Метод clear очищает множество, то есть удаляет из него все элементы.
s = Set[1,2,3,4,5,6]
s.empty?                                  # false
s.clear
s.empty?                                  # true
# Можно проверить, является ли одно множество подмножеством, собственным подмножеством или надмножеством другого.
x = Set[3,4,5]
y = Set[3,4]

x.subset?(y)                              # false
y.subset?(x)                              # true
y.proper_subset?(x)                       # true
x.subset?(x)                              # true
x.proper_subset?(x)                       # false
x.superset?(y)                            # true
# Метод add (синоним <<) добавляет в множество один элемент и обычно возвращает его в качестве значения.
# Метод add? возвращает nil, если такой элемент уже присутствовал в множестве. Метод merge полезен, если
# надо добавить сразу несколько элементов. Все они, конечно, могут изменить состояние вызывающего объекта.
# Метод replace работает так же, как и в случае строки или массива. Наконец, два множества можно сравнить
# на равенство очевидным способом:
Set[3,4,5] == Set[5,4,3]                  # true

# Более сложные операции над множествами.
# Ruby не гарантирует никакой последовательности при обходе множеств, временами можно получить повторяющиеся результаты
# но полагаться на это неразумно
s = Set[1,2,3,4,5]
s.each {|x| puts x; break }               # Выводится 5

# Метод classify подобен методу partition, но с разбиением на несколько частей;
# он послужил источником идеи для реализации вашей версии метода classify в разделе 8.3.3
files = Set.new(Dir["*"])
hash = files.classify do |f|
  if File.size(f) <= 10_000
    :small 
  elsif File.size(f) <= 10_000_000
    :medium 
  else
    :large
  end
end

big_files = hash[:large]                  # big_files - это Set

# Метод divide аналогичен, но вызывает блок, чтобы выяснить "степень общности" элементов,
# и возвращает множество, состоящее из множеств.
# Следующий блок (с арностью 1) разбивает множество на два подмножества, одно из которых содержит четные, а другое - нечетные числа:
require 'set'
numbers = Set[1,2,3,4,5,6,7,8,9,0]
set = numbers.divide{|i| i % 2}
p set          # #<Set: {#<Set: {5,1,7,3,9}>, #<Set: {0,6,2,8,4}>}>

# Простыми числами-близнецами называются простые числа отличающиеся на 2(например, 11 и 13); все
# остальные называются одиночными (например, 23). Следующий код разбивает множество на группы, помещая
#  числа-близнецы в одно и то же подмножестово. В данном случае применяется блок с арностью 2:
primes = Set[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
set = primes.divide{|i,j| (i-j).abs == 2}
# set is #<Set: { #<Set: {2}>, #<Set: {3, 5, 7}>, #<Set: {11, 13},
# #<Set: {17, 19}>, #<Set: {23}>, #<Set: {29, 31}> }>

# Более строгая реализация стека
# Вот пример простого класса, который хранит внутри себя массив и управляет доступом к этому массиву.
class Stack

  def initialize
    @store = []
  end

  def push(x)
    @store.push(x)
  end

  def pop
    @store.pop
  end

  def peek
    @store.last
  end

  def empty?
    @store.empty?
  end

end
# Мы добавили еще одну опеарацию, которая для массивов не определена; метод peek возвращает элемент,
# находящийся на вершине стека, не выталкивая его.

# Более строгая реализация очереди. Если вы хотите защититься от некорректного доступа к структуре данных,
# рекомендуем поступать аналогично.
class Queue

  def initialize
    @store = []
  end

  def enqueue(x)
    @store << x
  end

  def dequeue
    @store.shift
  end

  def peek
    @store.first
  end

  def length
    @store.length
  end

  def empty?
    @store.empty?
  end

end

# Решение задачи "Ханойская башня" с помощью стека (с тремя дисками)
def towers(list)
  while !list.empty?
    n, src, dst, aux = list.pop
    if n == 1
      puts "Перемещаем диск c #{src} на #{dst}"
    else
      list.push [n-1, aux, dst, src]
      list.push [1, src, dst, aux]
      list.push [n-1, src, aux, dst]
    end
  end
end

list = []
list.push([3, "a", "c", "b"])

towers(list)

# Конечно, классическое решение этой задачи рекурсивно. Но, как отмечалось, тесная связь между алгоритмами
# не должна вызывать удивления, т.к. для рекурсии применяется невидимый системный стек.
def towers(n, src, dst, aux)
  if n == 1
    puts "Перемещаем диск с #{src} на #{dst}"
  else
    towers(n-1, src, aux, dst)
    towers(1, src, dst, aux)
    towers(n-1, aux, dst, src)
  end
end

towers(3, "a", "c", "b")
# Печатается точно такой же результат. Но, рекурсивное решение оказалось в два раза быстрее.

# Обнаружение несбалансированных скобок.
def paren_match(str)
  stack = Stack.new
  lsym = "{[(<"
  rsym = "}])>"
  str.each_char do |sym|
    if lsym.include? sym
      stack.push(sym)
    elsif rsym.include? sym
      top = stack.peek
      if lsym.index(top) != rsym.index(sym)
        return false
      else
        stack.pop
      end
      # Игнорируем символы, отличные от скобок...
    end
  end
  # Убедимся, что стек пуст...
  return stack.empty?
end

str1 = "(((a+b))*((c-d)-(e*f))"
str2 = "[[(a-(b-c))], [[x,y]]]"

paren_match str1                 # false
paren_match str2                 # true

# Использование двоичного дерева как справочной таблицы
class Tree

  # Предполагается, что определения
  # взяты из предыдущего примера...

  def search(x)
    if self.data == x 
      return self
    elsif x < self.data
      return left ? left.search(x) : nil 
    else
      return right ? right.search(x) : nil 
    end
  end

end

keys = [50, 20, 80, 10, 30, 70, 90, 5, 14,
        28, 41, 66, 75, 88, 96]

tree = Tree.new

keys.each {|x| tree.insert(x)}

s1 = tree.search(75)                      # Возвращает ссылку на узел, содержащий 75...

s2 = tree.search(100)                     # Возвращает nil (не найдено)
