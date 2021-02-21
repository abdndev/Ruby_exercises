sym = %w[\\ | / -]

loop do
  sym.each do |s|
    x = "\r#{s} <--> Идет загрузка.."
    print x 
    #sleep rand(0.05..0.5)
    sleep 0.06
  end
end
