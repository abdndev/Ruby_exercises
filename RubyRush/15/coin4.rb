puts "Let's toss the coin and will know result (Давайте подбросим монету и узнаем результат.)..."

loop do
puts "Push Enter (Нажмите Enter):"
gets
if rand(11) == 10
  puts "Oops! It came edge of a coin! (Монета встала на ребро!)"
else
  if rand(2) == 1
    puts "It came up tails! (Выпала решка!)"
  else
    puts "It came up heads! (Выпал орел!)"
  end
end
end