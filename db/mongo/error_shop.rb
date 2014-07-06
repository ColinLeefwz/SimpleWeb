# 多个经纬度的商家， 当两个距离相差10000米，及是异常商家。
module ErrorShop
  def self.preform
    File.open("log/errshops","w+") do |f|
      sat = Time.now
      f.puts "开始执行时间：#{sat}"
      ns = Shop.new
      id = nil
      Shop.where({"$where" => "function(){if(this.lo){return this.lo[0] instanceof Array;}}"}).each do |shop|
        #      Shop.where({_id: {"$in" => [10532152, 10366463,48935]}}).each do |shop|
        begin
          shop.lo.combination(2).to_a.each do |bj|
            if (dis = ns.get_distance(bj[0], bj[1])) > 10000
              f.puts "错误商家id: #{shop.id}" if id != shop.id
              id = shop.id
              f.puts "            #{bj}相距#{dis}"
            end
          end
        rescue
          f.puts "出错商家: #{shop.id}, 错误信息：#{$!}"
          next
        end
      end
      eat = Time.now
      f.puts "执行完成时间: #{eat}"
      al = (eat -sat).to_i
      f.puts "此次执行时间：#{al/60}分#{al%60}秒"
    end
  end
end
