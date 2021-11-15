def result(a, b, c, d)
  if a == c && b == d
    puts 2
  elsif a > b && c > d || a < b && c < d || a == b && c == d
    puts 1
  else
    puts 0
  end
end

result(2, 1, 5, 3)
