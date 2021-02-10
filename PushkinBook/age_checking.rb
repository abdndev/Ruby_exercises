puts 'Your age?'
age = gets.to_i
if age >= 18
  puts 'Acces granted'
end

if age < 18
  puts 'Access denied!'
  #exit
end

puts "Today is your happy day! You will get a prize!" if age == 33
