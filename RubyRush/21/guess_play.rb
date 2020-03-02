number = rand(0..15)

puts 'Riddled a number between 0 to 15. Can you guess it?/Загадано число от 0 до 15, отгадайте какое?'


gnum = gets.strip.to_i
puts

if rand == gnum
  abort 'Ура, Вы выиграли!'
    elsif (rand - gnum).abs >= 3
      puts 'Холодно (нужно меньше)'
        elsif (rand - gnum).abs <= 2
          puts 'Тепло (нужно больше)'
end
    

