str = 'Мой электронный адрес igor@preved.com'
puts str.gsub(
  /[-0-9a-z_.]+@[-0-9a-z_.]+\.[a-z]{2,6}/,
  '<a href="mailto:\\0">\\0</a>'
)
