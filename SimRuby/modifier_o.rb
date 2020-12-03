def number
  puts 'Создаем случайное число'
  rand(0..1)
end

puts 'Без модификатора о'
3.times do
  if /#{number}/.match '0'
    puts 'Значение 0'
  else
    puts 'Значение 1'
  end
end

puts 'С модификатором о'
3.times do
  if /#{number}/o.match '0'
    puts 'Значение 0'
  else
    puts 'Значение 1'
  end
end
