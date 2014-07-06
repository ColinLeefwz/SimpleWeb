God.watch do |w|
  w.name = "mongo port forward"
  #w.start = "ssh -f -N -L 27017:127.0.0.1:27017 dooo@60.191.119.187 -p 2223"
  w.start = "ssh -f -N -L 27017:10.135.44.107:27017 lian@10.135.44.107"  
  w.keepalive
end

