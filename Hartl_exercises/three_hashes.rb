person1 = { first: 'Michael', last: 'Hartl' }
person2 = { first: 'Lynda', last: 'McCartney' }
person3 = { first: 'Petya', last: 'Ivanov' }

params = {} 
params[:father] = person1
params[:mother] = person2  
params[:child] = person3 

puts params
puts "The name of father is: #{params[:father][:first]}"
puts "The surname of mother is: #{params[:mother][:last]}"
puts "The surname of the son is: #{params[:child][:last]}"


