str = 'Дата представления 2019.10.28'
result = str.match /(\d{4})\.(\d{2})\.(\d{2})/
p result   # 2019.10.28
p result.to_a # ["2019.10.28", "2019", "10", "28"]
