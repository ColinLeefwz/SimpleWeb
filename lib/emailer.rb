# encoding: utf-8
class Emailer < ActionMailer::Base
  def send_mail(name,body)
    mail(:subject => name,
      :to =>['yuan_xin_yu@hotmail.com','huang123qwe@126.com'],
      :from => 'huang123qwe@126.com',
      :date => Time.now,
      :body => body
    )
  end

  def send_weibo_mail(name, body)
    mail(:subject => name,
      :to =>['yuan_xin_yu@hotmail.com','huang123qwe@126.com', "16186088@qq.com"],
      :from => 'huang123qwe@126.com',
      :date => Time.now,
      :body => body
    )
  end
  
  class SendWibo
    def self.count_weibo
      sus = SinaUser.where({}).count
      ius = SinaUser.where({is_I:true}).count
      sps = SinaPoi.where({}).count
      pps = SinaPoi.where({mtype:{"$exists" => true}}).count
      hls = HeatLoc.where({fetched: true}).count

      hangzhou = SinaPoi.where({city: '0571'})
      hpi = hangzhou.count
      hiu = hangzhou.inject(0) do |f, s|
        if s.respond_to?(:datas)
          f + s.datas.select{|data| data[2].to_s.match(/iphone|ipad/i)}.to_a.count
        else
          f
        end
      end

      photo_num = SinaPoiPhoto.count

      "用户数：#{sus};  其中ios系列用户：#{ius}; 杭州iso用户: #{hiu} \n 商家数：#{sps};  其中能匹配的商家数：#{pps}; 杭州商家: #{hpi} \n 已抓取的热门地点数： #{hls}; 完成度：#{(hls/110.92).round(3)}% \n \n 图片抓取个数: #{photo_num} "
    end

    def self.send_mail
      Emailer.send_weibo_mail('微博抓取情况', count_weibo.to_s).deliver
    end

  end

  class SendUserCity
    def self.send_mail
      Emailer.send_mail('城市分布统计(不含今天)', User.city_distribute.map{|m| "#{m[0]}:#{m[1]}"}.join(';  ') ).deliver
    end
  end
end