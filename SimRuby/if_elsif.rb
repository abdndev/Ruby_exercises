if RUBY_VERSION >= '2.5.3'
  puts 'Корректная версия Ruby'
elsif RUBY_VERSION >= '2.4.0'
  puts 'Проблемная версия Ruby'
else
  puts 'Некорректная версия Ruby'
end
