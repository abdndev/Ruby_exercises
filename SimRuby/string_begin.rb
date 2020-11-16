p 'Hello, world!'.match /world/  #<MatchData "world">
p 'Hello, Ruby!'.match /^world/  # nil
p 'world of Ruby'.match /^world/ #<MatchData "world">
