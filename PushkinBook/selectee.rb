
loop do

selectee_waits = rand(1..15)     # Selectee is waiting (months)

if selectee_waits > 12
  puts "Your visa approved!"
else
  puts "Drink water and breathe"
end

sleep 0.8
puts

end

