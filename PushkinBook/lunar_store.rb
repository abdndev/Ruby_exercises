puts
puts 'Hello! You are in Lunar-Store :)'
puts
puts 'Please Enter quantity of balls, which you want to buy...'
puts

print 'Soccer balls: '
sb = gets.strip.to_i
print 'Tennis balls: '
tb = gets.strip.to_i
print 'Golf balls: '
gb = gets.strip.to_i

obj = {
  soccer_ball: 68,
  tennis_ball: 10,
  golf_ball: 8
}

weight_value = sb * obj[:soccer_ball] + tb * obj[:tennis_ball] + gb * obj[:golf_ball]
earth_weight_value = (sb * obj[:soccer_ball] + tb * obj[:tennis_ball] + gb * obj[:golf_ball]) * 6
vkg_moon = (weight_value * 0.001).to_f

puts
puts "The total weight of playing balls on the Moon is: #{weight_value} gramms or #{vkg_moon} kilograms"
puts
puts "The total weight of playing balls on the Earth is: #{earth_weight_value} gramms "
puts
