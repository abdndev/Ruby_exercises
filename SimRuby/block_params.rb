def greeting
  yield 'Hello', 'Ruby'
end

greeting do |interjection, noun|
  puts "А теперь все вместе скажем: #{interjection}, #{noun}!"  # Hello, Ruby!
end
