class HelloWorld
  def say
    'Определяем метод say в первый раз'
  end
  def say
    'Определяем метод say во второй раз'
  end
end

hello = HelloWorld.new
puts hello.say # Определяем метод say во второй раз

