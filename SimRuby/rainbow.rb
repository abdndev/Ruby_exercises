class Rainbow
  COLORS = {
    red: 'красный',
    orange: 'оранжевый',
    yellow: 'желтный',
    green: 'зеленый',
    blue: 'голубой',
    indigo: 'синий',
    violet: 'фиолетовый',
  }

  COLORS.each do |method, name|
    define_method method do
      name
    end
  end
end

r = Rainbow.new
puts r.yellow # желтый
puts r.red    # красный

