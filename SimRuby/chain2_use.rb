require_relative 'chain2'

ticket = Ticket.new price: 600
puts ticket.buy.price   # 600
