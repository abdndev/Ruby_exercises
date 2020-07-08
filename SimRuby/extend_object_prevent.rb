module Hello
  def say(name)
    "Hello, #{name}!"
  end

  def self.extend_object(obj)
    puts 'Предотвращение включения модуля'
  end
end

ticket = Object.new
ticket.extend Hello  # Предотвращение включения модуля

puts ticket.say('Ruby')  # undefined method `say'
