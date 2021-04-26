class Car
  def initialize
    @state =  :closed
  end

  def open
    @state = :open
  end

  def how_are_you
    puts "My state is #{@state}"
  end
end

  car1 = Car.new
  car1.how_are_you

  car2 = Car.new
  car2.open
  car2.how_are_you

