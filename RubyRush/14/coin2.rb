puts "Let's toss the coin and will know result (Давайте подбросим монету и узнаем результат.)..."

c = ['It came up heads! (Выпал орел!)', 'It came up tails! (Выпала решка!)']

loop do
puts "Push Enter (Нажмите Enter):"
gets

puts c.sample
puts
end