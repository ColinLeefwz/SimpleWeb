require 'rubygems'
require 'RMagick'

class ProofImage
  include Magick
  attr_reader :text, :image
  Jiggle = 15
  Wobble = 15

  def initialize(len=4)
    chars = ('a'..'z').to_a # + ('0'..'9').to_a
    text_array=[]
    1.upto(len) {text_array << chars[rand(chars.length)]}
    background_type = "granite:" #花岗岩
    #background_type = "netscape:" #彩条
    #background_type = "xc:#EDF7E7" #指定背景色,例：xc:red
    #background_type = "null:" #纯黑
    granite = Magick::ImageList.new('xc:#EDF7E7')
    canvas = Magick::ImageList.new
    canvas.new_image(32*len, 50, Magick::TextureFill.new(granite))
    gc = Magick::Draw.new
    gc.font_family = 'times'
    gc.pointsize = 40
    cur = 10

    text_array.each{|c|
      rand(10) > 5 ? rot=rand(Wobble):rot= -rand(Wobble)
      rand(10) > 5 ? weight = NormalWeight : weight = BoldWeight
      gc.annotate(canvas,0,0,cur,30+rand(Jiggle),c){
        self.rotation=rot
        self.font_weight = weight
        self.fill = 'green'
      }
      cur += 30
    }
    
    @text = text_array.to_s
    puts @text
    @image = canvas.to_blob{
      self.format="GIF"
    }

    #生成图片文件
    #text.text(0, 0, " ")
    #text.draw(canvas)
    #canvas.write('test.gif') #图片位于项目根目录下。也可以使用linux中的绝对路径如:/home/chengang/test.gif

  end
end