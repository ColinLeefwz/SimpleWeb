width, heigth = ARGF.read(16+2*4).unpack("@16N2")
# @ Skips to the byte offset given by the length argument.
# N Treats 4 bytes as an unsigned long in network byte order.
puts "#{width},#{heigth}"
