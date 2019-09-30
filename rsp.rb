# encoding: cp866               

arr = [:rock, :scissors, :paper]

while true

puts "Let's play the Game (rock/scissors/paper)!"
print "What is Your choose? "
x = gets.strip

	if x == ""# && x != "rock" &&  x != "scissors" && x != "paper"  

		puts "Can't understand what you want, sorry..."
		exit
=begin
	elsif 
		puts "Can't understand what you want, sorry..."
		

	elsif 
		puts "Can't understand what you want, sorry..."
		

	elsif 
		puts "Can't understand what you want, sorry..."
		exit
=end
  end


a = rand(1..3)

	if a == 1
		puts "Computer choose is: #{arr[0]}" 

	elsif a == 2
		puts "Computeer choose is: #{arr[1]}" 

	else
		puts "Computer choose is: #{arr[2]}" 

	end

	if x == "rock" && a == 1
		puts "No winners! Try again!"
	
	elsif x == "rock" && a ==  2
		puts "Congrats, you Win!"

	elsif x == "rock" && a == 3
		puts "Computer Win! You are Lost!"

	elsif x == "scissors" && a == 1
		puts "Computer Win! You are Lost!"

	elsif x == "scissors" && a == 2
		puts "No winners! Try again!"

	elsif x == "scissors" && a == 3
		puts "Congrats, you Win!"

	elsif x == "paper" && a == 1
		puts "Congrats, you Win!"

	elsif x == "paper" && a == 2
		puts "Computer Win! You are Lost!"

	elsif x == "paper" && a == 3
		puts "No winners! Try again!"

	end

end
