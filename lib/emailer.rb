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

  def smail(name, toa, body)
    mail(:subject => name,
      :to =>toa,
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

      #      photo_num = SinaPoiPhoto.count
      sf_num = SinaFriend.count

      "用户数：#{sus};  其中ios系列用户：#{ius}; 杭州iso用户: #{hiu} \n 商家数：#{sps};  其中能匹配的商家数：#{pps}; 杭州商家: #{hpi} \n 已抓取的热门地点数： #{hls}; 完成度：#{(hls/110.92).round(3)}% \n \n 已抓微博好友个数: #{sf_num} "
    end

    def self.send_mail
      Emailer.send_weibo_mail('微博抓取情况', count_weibo.to_s).deliver
    end

  end

  module SendDayStat

    def self.day_stat
      test_shop = [21828775,21830326,21830327,21830785, 21830784]
      day = 1.days.ago
      day = "#{day.month}月#{day.day}日"

      #注册用户
      uc =  User.where({auto:nil}).count

      #每日注册用户
      ucd = UserCityDay.last.datas
      #前三城市
      qiansan = ucd.sort{|s,f| f.last <=> s.last}[0,3].map { |m| "#{City.gname(m[0])}: #{m[1].to_i}" }.join(";")
      #杭州注册
      hz = ucd.fetch('0571', 0).to_i

      #每日注册机型
      uds = UserDeviceStat.last

      #每日总用户数
      dus = (uds.cios+uds.card).to_i

      #昨日合作商家下载次数
      cdss = CouponDayStat.where({day: 1.days.ago.strftime("%Y-%m-%d"), sid: {"$nin" => test_shop}}).sort({dcount: -1})

      #下载次数
      xiazai = cdss.sum(&:dcount)
      #使用次数
      shiyong = cdss.sum(&:ucount)
      #下载最多商家
      xzd = cdss.first


      <<-DAYSTAT
      注册用户共#{uc}人
      昨日新增用户#{dus}人杭州#{hz}人，ios #{uds.cios.to_i}人，安卓#{uds.card.to_i}人；新增城市排名 前三（#{qiansan}）

      日期	   新增用户	  杭州	  ios	  安卓	   累积用户
      #{day}   #{dus}	     #{hz}  	  #{uds.cios.to_i}  	   #{uds.card.to_i}  	   #{uc}

        合作商家优惠券使用情况统计，共下载#{xiazai}次 使用#{shiyong}次 使用率(#{(shiyong*100/xiazai.to_f).round(3)})%

         #{xzd.shop.name} 下载#{xzd.dcount}次 使用#{xzd.ucount}次
      DAYSTAT
    end

    def self.send_mail
      toa = ['149235521@qq.com', 'yinghk@163.com', 'yuan_xin_yu@hotmail.com', 'puxizhe@163.com', '16186088@qq.com',
        '35473820@qq.com', 'heyibing@gmail.com', 'huang123qwe@126.com']
      #      toa = ['huang123qwe@126.com', '345699420@qq.com']
      head = "#{Time.now.strftime("%m月%d日")}脸脸相关数据统计"
      Emailer.smail(head, toa, day_stat).deliver
    end

  end

  class SendUserCity
    def self.send_mail
      Emailer.send_mail('城市分布统计(不含今天)', User.city_distribute.map{|m| "#{m[0]}:#{m[1]}"}.join(';  ') ).deliver
    end
  end
end