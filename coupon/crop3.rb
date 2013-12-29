# coding: utf-8
# 把图片压缩到(x,y)大小，长边剪裁

if ARGV.size<4
  puts "url x, y output_filename"
  exit -1
end

file = ARGV[0]
x = ARGV[1].to_i
y = ARGV[2].to_i
out = ARGV[3]
`convert -auto-orient -resize #{x}x#{y}^ #{file} #{out}`
str = `identify -verbose #{out} | grep 'Geometry' `
puts str # Geometry: 600x234+0+0
w, h = str.split(":")[1].split("+")[0].split("x").map {|x| x.to_i}
if w>x
  d = (w-x)/2
  `mogrify -shave #{d} #{out}`
elsif h>y
  d = (h-y)/2
  `mogrify -shave x#{d} #{out}`  
end


