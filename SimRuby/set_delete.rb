require 'set'

workday = Set.new %w[monday tuesday wednesday thursday friday]

p workday.delete 'tuesday'
p workday.delete 'thursday'

