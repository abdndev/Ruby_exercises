# encoding: cp866

def get_password
	print "Type password: "   # ������ ��஫�
       #return gets.strip
	gets.chomp * 3
end

xx = get_password

puts "�� ������ ��஫�: #{xx}"

gets