require_relative 'ticket'

ticket = Ticket.new price: 600
p Marshal.dump(ticket)
