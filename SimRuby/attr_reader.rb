class Ticket
  attr_reader :data, :price
  
  def initialize(date:, price: 500)
    @price = price
    @date = date
  end

  def price=(price)
    @price
  end

  def date=(date)
    @date = date
  end
end
