###################################################
# ОПРЕДЕЛЯЕМ ПЕРЕМЕННЫЕ
###################################################

@humans = 10_000
@machines = 10_000

###################################################
# ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
###################################################

# Метод возвращает случайное значение: true или false
def luck?
  rand(0..1) == 1
end

def boom
  diff = rand(1..5)
  if luck?
    @machines -= diff
    puts "#{diff} машин уничтожено"
  else
    @humans -= diff
    puts "#{diff} людей погибло"
  end        
end