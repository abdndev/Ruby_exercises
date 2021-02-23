def pass_secret
  print "Введите ваш пароль: "
  pass = gets.strip
  a = pass.size
  b = "*"
  print "Ваш пароль: #{b * a}\n"   
end

pass_secret
