
loop do

dq = rand(0..1)                  # Selectee DQ status
selectee_waits = rand(1..15)     # Selectee is waiting (months)

if dq == 0
  puts "Sasay! Just Sasay!"
elsif selectee_waits > 12
  puts "Your visa approved!"
else
  puts "Drink water and breathe"
end

sleep 0.8
puts

end

