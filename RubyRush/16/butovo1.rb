puts "Вы решили прогуляться в Южном Бутово и наткнулись на спортивных ребят
1. Попытаться убежать
2. Продолжить идти"

choice = gets.chomp

if choice == "1"
  abort "Ребя без труда догнали вас и побили. Не знаю за что."
else
  puts "Один из ребят вышел вперед и спросил \"Сиги есть?\"
  1. Дать прикурить
  2. -- Не курю
  3. Сказать \"Нету\""
  choice = gets.chomp

  if choice == "1"
  	abort "Прикурив, ребята отправились дальше"
  elsif choice == "2"
    abort "Ребята расстроились и побили вас. Теперь уже ясно за что."

  elsif choice == "3"
    puts "Подошедший пацан спросил \"А если найду?\"
    1. Дать обыскать карманы
    2. Ответить, \"Мой брат знает вашего старшего на районе Зюзю. Ровные пацаны карманы не показывают.\""
   
   choice = gets.chomp

  
    if choice == "1"
      puts "Получив пинка под зад, идти дальше под свист шпаны..."
      exit 
    elsif choice == "2"
     abort "Подошедший пацан узнает в тебе знакомое лицо: \"А-а-а, братик, Мажуха твой брательник? Извини - не признал. 
Иди с миром и брату привет передавай от Козареза!\""
  end
 end
end
