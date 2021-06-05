# Построчная обработка
str = "Когда-то\nдавным-давно...\nКонец\n"
num = 0
str.each_line do |line|
    num += 1
    print "Строка #{num}: #{line}"
end
