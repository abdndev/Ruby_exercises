# encoding: cp866
class Animal
	def run
		puts "I'm running!"
	end
	def run_rus
		puts "� 㦥 ����!"
	end

end

a = Animal.new
a.run
puts a

b = Animal.new
b.run_rus
puts b