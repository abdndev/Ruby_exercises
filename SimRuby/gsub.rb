str = 'Цена билета увеличилась с 500 до 600 рублей'
p str.sub(/\d+/, '700')  # "Цена билета увеличилась с 700 до 600 рублей"
p str.gsub(/\d+/, '700') # "Цена билета увеличилась с 700 до 700 рублей"