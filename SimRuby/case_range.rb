number = rand(0..110)

case number
when 0..50
  puts 'От нуля до 50';
when 51..100
  puts 'От 51 до 100'
else
  puts 'Число не входит в диапазон от нуля до ста'
end