def animate
  a = []
  3.times do |i|
    6.times do |j|
      a[i] = j+1
      print a.join(" ")+"\r"
      sleep 0.05
    end
  end
end

animate
