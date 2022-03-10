def replace(array)
  m = array.max
  array.map { |x| x > 0 ? "#{m}".to_i : x }
end

