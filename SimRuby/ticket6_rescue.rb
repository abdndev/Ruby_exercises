require_relative 'ticket6'

begin
  10.times.map do |i|
    p Ticket.new date: Time.new(2019, 5, 10, 10, 1)
  end

  puts ticket.size
rescue
  puts 'Возникла ошибка'
end
