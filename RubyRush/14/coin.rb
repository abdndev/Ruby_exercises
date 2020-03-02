puts "Let's toss the coin and will know result (Давайте подбросим монету и узнаем результат.)..."

loop do
puts "Push Enter (Нажмите Enter):"
gets
c = rand(0...2)

puts c
puts

if c == 0
  puts "It came up heads! (Выпал орел!)"
elsif c == 1
  puts "It came up tails! (Выпала решка!)"
end

end