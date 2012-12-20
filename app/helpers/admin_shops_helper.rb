# encoding: utf-8
module AdminShopsHelper
  def import_type
    types = []
    File.open('db/mongo/baidu-mapabc-merge/type.txt', 'r') do |f|
      f.each_line{|l| types << l.scan(/[\u4e00-\u9fa5;\/a-zA-Z]+/)}
    end
    types = (types-[[]]).reject{|r| r[0] =~ /^(金融|医疗)/}.unshift(['',''])
  end
end
