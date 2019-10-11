# encoding: cp866

class Book

	def initialize                        
 		@hh = {}
	end

	def add_person  options
		# добавляет пару в хэш
		puts 'Already exists!' if @hh[options[:name]]
		@hh[options[:name]] = options[:age]
		@last_prsn =  @hh[options[:name]] = options[:age]   # назначаем переменную для вывода значения из хэша
		@n = options[:name]                              # назначаем переменную для ключа в хэше
	end

	def show_last_prsn                                # создаем метод(функцию) для вывода последнего ключа и значения из хэша
		puts "Last person: #{@n}, #{@last_prsn}"

	end

	def show_all
		# показывает хэш
		@hh.keys.each do |key|
			age = @hh[key]
			puts "Name: #{key}, age: #{age}"
		end

	end

	def aa
	    @hh   # можно перед @hh написать return
	end

end
b = Book.new
b.add_person :name => 'Walt', :age => 50
#b.show_all                                             

c = Book.new
c.add_person :name => 'Vasya', :age => 34
c.add_person :name => 'Sanya', :age => 36


#b.show_all
c.add_person :name => 'Zoe', :age => 39
#puts c.aa
c.add_person :name => 'Sosun', :age => 65
c.add_person :name => 'Kostyan', :age => 45
c.add_person :name => 'Lopushandriy', :age => 29
c.add_person :name => "Kozlenok", :age => 43
c.show_all
puts  c.show_last_prsn

