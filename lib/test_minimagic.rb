require 'rubygems'
require 'mini_magick'

image = MiniMagick::Image.from_file("public/bg.png")
image.combine_options do |c|
	c.pointsize(40)
	c.draw("text 20,30  'test'")
end
image.write("test.png")

exit

