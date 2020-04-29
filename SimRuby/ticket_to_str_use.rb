require_relative 'ticket_to_str'

ticket = Ticket.new date: Time.mktime(2019, 5, 11, 10, 20)
puts 'Билет: ' + ticket
# Билет: цена 500, дата 2019-05-11 10:20:00 +0300
