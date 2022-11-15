# Утка
class Duck
  def walk
  end

  def quack
  end
end

# Собака
class Dog
  def walk
  end

  def quack
  end
end

# Утиный командир, который дает разные команды
class DuckCommander
  def command(who)
    who.walk
    who.quack
  end
end

# Создадим утку и собаку
duck = Duck.new
dog = Dog.new

# Покажем, что утиный командир может командовать собакой
# и уткой, и при этом не возникает никакой ошибки
dc = DuckCommander.new
dc.command(duck)
dc.command(dog)
