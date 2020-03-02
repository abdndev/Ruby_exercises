fst,snd, thd = 'Hello', ['world', '!']
p fst # "Hello"
p snd # ["world", "!"]
p thd # nill

fst, snd, thd = 'Hello', *['world', '!']
p fst # "Hello"
p snd # "world"
p thd # "!"