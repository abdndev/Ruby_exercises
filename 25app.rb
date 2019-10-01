require 'sqlite3'

db = SQLite3::Database.new 'mydatabase.db'

db.execute "CREATE TABLE "Motos" ("Id" INTEGER PRIMARY KEY AUTOINCREMENT, "Name" VARCHAR, "Price" INTEGER)" 

db.execute "INSERT INTO Cars (Name, Price) VALUES ('Jaguar', 7777)"

db.close