puts 'This program will output our three clients data'
puts
print 'First client, please enter your name: '
cname1 = gets.strip.capitalize
print 'First client, please enter your date of birth: '
cdate1 = gets.strip
print 'First client, please enter your place of birth: '
cplace1 = gets.strip.capitalize
print 'First client, please enter your phone number: '
cphone1 = gets.strip.to_s
puts

print 'First client, please enter your name: '
cname2 = gets.strip.capitalize
print 'First client, please enter your date of birth: '
cdate2 = gets.strip
print 'First client, please enter your place of birth: '
cplace2 = gets.strip.capitalize
print 'First client, please enter your phone number: '
cphone2 = gets.strip.to_s
puts

print 'First client, please enter your name: '
cname3 = gets.strip.capitalize
print 'First client, please enter your date of birth: '
cdate3 = gets.strip
print 'First client, please enter your place of birth: '
cplace3 = gets.strip.capitalize
print 'First client, please enter your phone number: '
cphone3 = gets.strip.to_s
puts

puts '======================================='
puts "name: #{cname1}"
puts "date of birth: #{cdate1}"
puts "place of birth: #{cplace1}"
puts "phone: #{cphone1}"
puts '======================================='