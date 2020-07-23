require_relative 'ticket'

ticket = Ticket.new price: 600
p ticket
str = Marshal.dump(ticket)
t = Marshal.load(str)

p t
p t == ticket
puts t.price
