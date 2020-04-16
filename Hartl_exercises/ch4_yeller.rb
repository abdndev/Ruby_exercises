def yeller(x, y, z)
  arr = []
  arr << x << y << z
  arr.map { |char| char.upcase }.join
end

p yeller('o', 'l', 'd')

