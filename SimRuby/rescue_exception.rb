require_relative 'ticket6'

begin
  10.times.map do |i|
    p Ticket.new date: Time.new(2019, 5, 10, 10, i)
  end

  puts tickets.size
rescue => e
  p e
  p e.class
  p e.message
  p e.backtrace
end
