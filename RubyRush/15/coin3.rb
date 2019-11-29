puts "Let's toss the coin and will know result (Давайте подбросим монету и узнаем результат.)..."
puts

loop do
puts
puts "Push Enter (Нажмите Enter):"
gets
c = rand(0...100)

#puts c
puts

if c >= 0 && c <=45
  puts "It came up heads! (Выпал орел!)"
elsif c >= 56 && c <= 100 
  puts "It came up tails! (Выпала решка!)"
else
  puts "Oops! It came edge of a coin! (Монета встала на ребро!)"
end

end