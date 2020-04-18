person1 = { first: 'Michael', last: 'Hartl' }
person2 = { first: 'Lynda', last: 'McCartney' }
person3 = { first: 'Petya', last: 'Ivanov' }

params = {} 
params[:father] = person1
params[:mother] = person2  
params[:child] = person3 

puts params
puts params[:father][:first]
puts params[:mother][:last]
puts params[:child][:last]

