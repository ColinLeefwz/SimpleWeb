# coding: utf-8
# 把一个矩形图片切割为方形

if ARGV.size<1
  puts "please input filename"
  exit -1
end

file = ARGV[0]
str = `identify -verbose #{file} | grep 'Geometry' `
puts str # Geometry: 600x234+0+0
w, h = str.split(":")[1].split("+")[0].split("x").map {|x| x.to_i}
if w>h
  d = (w-h)/2
  `mogrify -shave #{d} #{file}`
elsif w<h
  d = (h-w)/2
  `mogrify -shave x#{d} #{file}`  
end


