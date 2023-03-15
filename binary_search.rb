# recursive binary search

def search(_array, _query, min_indx = 0, max_indx = _array.length - 1)
  return -1 if min_indx > max_indx
      
  i = (min_indx + max_indx)/2
      
  if _array[i] > _query
    search(_array, _query, 0, i - 1)
  elsif _array[i] < _query
    search(_array, _query, i + 1, max_indx) #_array.length - 1)
  else
    return i
  end
end

puts search([1, 4, 5, 7, 8, 9], 6)
