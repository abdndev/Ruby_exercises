# encoding: cp866

class Book

	def initialize                        
 		@hh = {}
	end

	def add_person  options
		# �������� ���� � ���
		puts 'Already exists!' if @hh[options[:name]]
		@hh[options[:name]] = options[:age]
		@last_prsn =  @hh[options[:name]] = options[:age]   # �����砥� ��६����� ��� �뢮�� ���祭�� �� ���
		@n = options[:name]                              # �����砥� ��६����� ��� ���� � ���
	end

	def show_last_prsn                                # ᮧ���� ��⮤(�㭪��) ��� �뢮�� ��᫥����� ���� � ���祭�� �� ���
		puts "Last person: #{@n}, #{@last_prsn}"

	end

	def show_all
		# �����뢠�� ���
		@hh.keys.each do |key|
			age = @hh[key]
			puts "Name: #{key}, age: #{age}"
		end

	end

	def aa
	    @hh   # ����� ��। @hh ������� return
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

