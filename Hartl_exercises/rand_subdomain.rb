def random_subdomain
  ('a'..'z').to_a.shuffle[0..7].join
end

puts random_subdomain

