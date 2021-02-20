sym = %w[\\ | / -]
#print 'Formatting hard drive'


loop do
  sym.each do |s|
    x = "\r#{s}"
    print x 
    #print "#{s}\r" 
    #sleep rand(0.05..0.5)
    sleep 0.06
  end
  
end
