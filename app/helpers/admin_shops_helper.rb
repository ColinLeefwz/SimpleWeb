module AdminShopsHelper
  def import_type
    types = []
    File.open('db/mongo/baidu-mapabc-merge/type.txt', 'r') do |f|
      f.each_line{|l| types << l.scan(/[\u4e00-\u9fa5;]+/)}
    end
    (types-[[]]).map{|m| m.push(m[0])}.unshift(['',''])
  end
end
