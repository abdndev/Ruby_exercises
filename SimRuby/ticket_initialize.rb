class Ticket
  def initialize
    puts 'Установление начального состояния объекта'
    @price = 500
  end

  def set_price(price)
    @price = price
  end

  def price
    @price
  end
end
