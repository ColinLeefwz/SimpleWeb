require 'rubygems'
require 'Rmagick'

class ValidateImage
include Magick
attr_reader :code, :code_image
Jiggle = 15
Wobble = 15
def initialize(len)
chars = ('a'..'z').to_a - ['a','e','i','o','u']
code_array=[]
#���������֤����ĸ
1.upto(len) {code_array << chars[rand(chars.length)]}
#����granite��ʽ�ı���
granite = Magick::ImageList.new('xc:#EDF7E7')
#���廭��
canvas = Magick::ImageList.new
#��granite��ӵ�������
canvas.new_image(32*len, 50, Magick::TextureFill.new(granite))
#��������
text = Magick::Draw.new
#������������
text.font_family = 'times'
#�������ִ�С
text.pointsize = 40
cur = 10
code_array.each{|c|
rand(10) > 5 ? rot=rand(Wobble):rot= -rand(Wobble)
rand(10) > 5 ? weight = NormalWeight : weight = BoldWeight
#��text������ӵ�canvas��
text.annotate(canvas,0,0,cur,30+rand(Jiggle),c){
self.rotation=rot #��ת�Ƕ�
self.font_weight = weight #text�����֣���С
self.fill = 'green' #text�����֣���ɫ
}
cur += 30
}
#������֤�����֣�������ת��Ϊ�ַ�����
@code = code_array.to_s
#���ɶ�����ͼƬ
@code_image = canvas.to_blob{
self.format="JPG"
}
canvas.write('test.gif')
end
end