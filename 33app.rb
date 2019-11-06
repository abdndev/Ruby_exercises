print "Enter product id: "
id = gets.chomp

print "Enter amount (how much items you want to order): " 
n = gets.chomp.to_i

hh = {}
hh[id] = n

puts hh.inspect