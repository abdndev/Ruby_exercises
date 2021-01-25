#Get My Number Game
#Written by Me!

puts "Welcome to 'Get My Number!'"
print "What's your name? "
input = gets.strip.capitalize

puts "Welcome, #{input}!"
puts "I've got a random number between 1 and 100."
puts "Can yo guess it?"

target = rand(101)

num_guesses = 0

loop do
num_guesses += 1

puts "You've got #{11 - num_guesses} guesses left."

print "Enter your choice (1-100): "
user_choice = gets.to_i

if user_choice < target
    puts 'Oops. Your guess was LOW'
elsif user_choice > target
    puts 'Oops. Your guess was HIGH'
elsif user_choice == target
    puts "Good job, #{input}! You guessed my number in #{num_guesses} guesses!"
    exit
end
puts
if num_guesses == 10
    puts "Sorry. You didn't get my number. My number was #{target}" 
    exit
end    
#puts num_guesses
end
