require 'sqlite3'
# демонстрация работы с базой данных
db = SQLite3::Database.new 'test.sqlite'

#db.execute "INSERT INTO Cars (Name, Price) VALUES ('Mazda', 9977)"
#db.execute "INSERT INTO Cars (Name, Price) VALUES ('Pontiak', 12657)"
#db.execute "INSERT INTO Cars (Name, Price) VALUES ('Jaguar', 8888)"
#db.execute "INSERT INTO Cars (Name, Price) VALUES ('Lada', 5576)"

db.execute "SELECT * FROM Cars" do |car|
	print car
	puts ""
end

db.close
