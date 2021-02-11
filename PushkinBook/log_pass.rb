puts 'Please, enter your login: '
login = gets.strip

puts 'Please, enter your password: '
pass = gets.strip

if login == 'admin' && pass == '12345'
  puts 'Доступ к банковской ячейке разрешен'
else
  puts 'Доступ запрещен!'
end
