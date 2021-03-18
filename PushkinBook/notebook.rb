arr = []

loop do
  print 'Введите имя и телефон человека (Enter для окончания ввода): '
  entry = gets.chomp
  break if entry.empty?
  #arr << entry
  arr.push(entry)
end
puts

puts 'Ваша записная книжка: '
puts

arr.each do |element|
  puts element
  puts "=" * 30
end
