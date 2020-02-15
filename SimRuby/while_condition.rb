def condition
  @i ||= 0
  @max_iterations ||= begin
    print 'Пожалуйста, введите количество повторов: '
    gets.to_i
  end

  @i += 1
  @i <= @max_iterations
end

puts @i while condition 