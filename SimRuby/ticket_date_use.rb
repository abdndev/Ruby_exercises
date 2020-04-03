require_relative 'ticket_date'
first = Ticket.new(date: Time.mktime(2020, 2, 10, 10, 20))

puts "Дата билета first: #{first.date}"
puts "Цена билета first: #{first.price}"

second = Ticket.new(date: Time.mktime(2020, 3, 9, 8, 20))

puts "Дата билета second: #{second.date}"
puts "Цена билета second: #{second.price}"

