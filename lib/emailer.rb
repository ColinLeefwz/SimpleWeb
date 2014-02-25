# encoding: utf-8
require 'rexml/document'
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

         短信剩余量: #{REXML::Document.new(SmsSender.ihuiyi_remain).root.elements['num'].text}条

      DAYSTAT
    end

    def self.send_mail
      toa = ['yinghk@163.com', 'yuan_xin_yu@hotmail.com', 'puxizhe@163.com', '16186088@qq.com',
         'heyibing@gmail.com', 'huang123qwe@126.com',"454413959@qq.com" ]
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