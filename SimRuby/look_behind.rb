str = 'Цена билета в кино 700 рублей. Цена проезда $10'
puts str.gsub(/(?<=\$)\d+/) { |x| "#{x} (#{x.to_i * 66} руб.)" }
