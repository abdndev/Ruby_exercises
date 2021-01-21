# игра "однорукий бандит"

hh = { '111' => 100, '222' => 200, '333' => 300,'444' => 400, '555' => 500, '666' => 600, '777' => 1000, '888' => 800, '999' => 900 }

balance = 100

loop do
     puts "Press Enter to play..."
     gets

     a = rand(100..999).to_s
     puts "Current combination: #{a}"
     if hh.has_key? "#{a}"
	puts "Congrats, You win #{hh[a]} dollars"
     balance = balance + hh[a]
     puts "Your balance: #{balance} dollars"
	else balance = balance - 1
		puts "You did't win, but lose 1 dollar, try again..."	

	
     puts "Your balance: #{balance} dollars"

   end
end