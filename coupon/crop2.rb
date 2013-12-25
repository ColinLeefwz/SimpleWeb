# coding: utf-8
# 以x,y为中心点把一个矩形图片切割为方形

if ARGV.size<3
  puts "usage: filename x y"
  exit -1
end

file = ARGV[0]
x = ARGV[1].to_i
y = ARGV[2].to_i-10 #鼻子为中心点上移动5px
str = `identify -verbose #{file} | grep 'Geometry' `
puts str # Geometry: 600x234+0+0
w, h = str.split(":")[1].split("+")[0].split("x").map {|x| x.to_i}



if x==0 || y==0 || x>w-50 || y>h-50 || x<50 || y<50
  if w>h
    d = (w-h)/2
    `mogrify -shave #{d}x #{file}`
  elsif w<h
    d = (h-w)/2
    `mogrify -shave x#{d} #{file}`  
  end
else
  x2 = w-x
  y2 = h-y
  arr = [x,x2,y,y2]
  min = arr.min
  offsetx = x-min
  offsety = y-min
  width = 2*min
  height = width
  `mogrify -crop #{width}x#{height}+#{offsetx}+#{offsety} #{file}`
end



