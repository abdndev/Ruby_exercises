# телефонная книга
hh = {}

while true
print "Enter name (Enter to stop): "
name = gets.strip.capitalize

print "Enter phone number: "
phone = gets.to_i

hh["#{name}"] = phone 

#=begin
	if name == ""
	#elsif phone == ""
	puts hh
        exit
	end
#=end

#puts hh
end
