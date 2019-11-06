hh = {}



loop do

	print 'Enter product id: '
	id = gets.chomp

	print 'Enter amount (how much items you want to order): ' 
	n = gets.chomp.to_i

	x = hh[id].to_i  # read hash value (0 if it's not exist)
	x = x + n        # increase by n
	hh[id] = x       # set hash value

	puts hh.inspect
	puts '====================================='

end