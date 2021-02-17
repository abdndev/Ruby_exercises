number = rand(1..100)
print 'Привет! Я загадал число от 1 до 100, попробуйте угадать: '

loop do
  input = gets.to_i

  if input == number
    puts 'Правильно!'
    exit
  elsif input < number 
    print 'Искомое число больше вашего ответа, попробуйте еще раз: '
  elsif input > number
    print 'Искомое число меньше вашего ответа, попробуйте еще раз: '
  end
end