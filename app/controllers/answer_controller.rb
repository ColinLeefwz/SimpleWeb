# coding: utf-8

class AnswerController < ApplicationController

  layout nil
  
  def shop
    sid = params["sid"]
    uid = params["uid"]
    msg = params["msg"]
    mid = params["mid"]    
    Xmpp.send_gchat2(uid,sid,uid,msg,mid, nil, " NOLOG='1' ")
    if msg=="@@@"
      response = Xmpp.get("api/room_users?roomid=#{sid}")
      names = JSON.parse(response).map{|x| User.find_by_id(x).name}
      Xmpp.send_gchat2($gfuid,sid,uid, names.join("\n") )
      render :text => "1"
      return
    end
    if msg=="@@@id"
      Xmpp.send_gchat2($gfuid,sid,uid, sid.to_s)
      render :text => "1"
      return
    end
    shop = Shop.find_by_id(sid)
    user = User.find_by_id(uid)
    return render :text => "1" if shop.preset?(user) && pre_answer(msg, user, shop)
    text_faq = shop.answer_text(msg)
    @text = text_faq if ENV["RAILS_ENV"] == "test"
    if text_faq
      if text_faq.class == ShopFaq
        text_faq.send_to_room(uid,sid)
      else
        Xmpp.send_gchat2($gfuid,sid,uid, text_faq, "FAQ#{sid}#{uid}#{Time.now.to_i}")
      end
    else
      Xmpp.error_notify("问答返回nil:#{sid},#{uid},#{msg}")
    end
    render :text => "1"
  end
  
  def at3
    if is_kx_user?(params[:from]) || User.is_fake_user?(params[:from]) || params[:from]==$gfuid
      txt = params["msg"]
      attrs = " NOLOG='1' NOPUSH='1' "
      ext = nil
      url = "dface://scheme/seek/relocate"
      if txt[0,6]=="@@@我要去"
        city = City.city_code(txt[6..-1])
        if city
          $redis.set("FCITY#{params[:from]}",city)
          attrs += " url='#{url}' " 
          ext = "<x xmlns='dface.url'>#{url}</x>"
          Xmpp.send_chat(params[:to],params[:from],"已到#{txt[6..-1]}，点击重新定位", nil, attrs, ext)
        else
          Xmpp.send_chat(params[:to],params[:from],"抱歉，找不到#{txt[6..-1]}", $uuid.generate, " NOLOG='1' NOPUSH='1' ")
        end
        render :text => "1"
        return
      end
      if txt=="@@@我要回来"
        $redis.del("FCITY#{params[:from]}")
        attrs += " url='#{url}' " 
        ext = "<x xmlns='dface.url'>#{url}</x>"
        Xmpp.send_chat(params[:to],params[:from],"回来了，点击重新定位", nil, attrs, ext)
        render :text => "1"
        return
      end
      user = User.find(params[:to])
      unless user
        render :text => "user not exists"
        return   
      end
      ud = UserDevice.find(user.id)
      os = ""
      if ud
        ver = ud.ds[0][3]
        os = "#{ud.ds[0][1]},脸脸版本#{ver}"
      end
      str = <<-EOF   
#{user.name} : #{user.show_gender},#{user.age},#{user.gonstellation}
注册时间: #{user.cat_day}
最新动态：#{user.last_location[:last]} #{City.fullname(user.city)}
头像数量: #{user.pcount}
签名: #{user.signature}
爱好: #{user.hobby}
系统: #{os}
      EOF
      Xmpp.send_chat(params[:to],params[:from],str, $uuid.generate, " NOLOG='1' NOPUSH='1' ")
      render :text => "1"      
    else
      render :text => "0"      
    end
  end
  
  def admin
    uid = params["uid"]
    if uid == $gfuid
      render :text => "1"
      return
    end
    txt = params["msg"]
    int = txt.to_i
    if int==1
      msg1(uid)
      msg2(uid)
    elsif  txt=="0" || txt=="o" || txt=="O" || txt=="〇"
      msg3(uid)
    elsif  (int>1 && int<8)
      want(uid,int)
    elsif  txt=="?" || txt=="？"
      faq(uid)
    elsif txt=="ip" && is_kx_user?(uid) 
      Xmpp.send_chat($gfuid, uid, "Xmpp服务器ip：#{read_ip}", $uuid.generate, " NOLOG='1' NOPUSH='1' ")      
    elsif txt.downcase=="hi"
      Resque.enqueue_in(3.seconds,XmppMsg, $gfuid,uid,"hi😄")
    elsif txt[0,2]=="您好" || txt[0,2]=="你好"
      Resque.enqueue_in(3.seconds,XmppMsg, $gfuid,uid,"您好😄")
    elsif txt=="你是" || txt[0,3]=="你是谁"
      Resque.enqueue_in(5.seconds,XmppMsg, $gfuid,uid,"我是脸脸客服😊")
    elsif txt.match /摇了摇手机/
      sec = rand(30)
      Resque.enqueue_in(sec.seconds,XmppMsg, $gfuid,uid,"脸脸网络也摇了摇手机")   if sec < 25
      Resque.enqueue_in(sec.seconds,XmppMsg, $gfuid,uid,"摇手机过猛，手机甩出去了") if sec > 20      
    elsif txt.match /怎么玩/
      Resque.enqueue_in(3.seconds,XmppMsg, $gfuid,uid,"到每个地方，可以拍照分享照片😊")  
      Resque.enqueue_in(10.seconds,XmppMsg, $gfuid,uid,"可以在现场和热点里找人聊天")  
      Resque.enqueue_in(20.seconds,XmppMsg, $gfuid,uid,"还可以邀请好友一起玩。好友在你附近时可以自动提醒😄")        
    elsif txt.bytesize==4
      txt = "😄💛🌟😜😊😊😊💤💤💤💤🙏🙏"
      sec = rand(10)
      Resque.enqueue_in(sec.seconds,XmppMsg, $gfuid,uid, txt[rand(13)])
    elsif txt.to_i.to_s==txt
      want(uid,txt[0].to_i)
    elsif txt.bytesize<=3
      Rails.cache.fetch("HELP#{uid}", :expires_in => 12.hours) do
        help_msg(uid)
        "1"
      end
    else
      Resque.enqueue(XmppMsg, uid,User.first.id,":反馈："+txt)
    end
    render :text => "1"
  end

  private
  
  def msg1(from)
    str = <<-EOF   
  1、现场拍照，并分享到微博或QQ
  2、带上'我是地主'四个字
  即可获得地主徽章，效果图如下：
    EOF
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end

  def msg2(from)
    str = "[img:U51aea9d4c90d8bbc1200006f]"
    Resque.enqueue_in(3.seconds, XmppMsg, $gfuid,from,str)
  end

  def msg3(from)
    str = <<-EOF   
  试试：
  回复2、遇见一位同城异性
  回复3、遇见一位同龄异性
  回复4、遇见一位国外异性
  回复?、常见问题解答
    EOF
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end

  def faq(from)
    str = <<-EOF   
  问：我摇的每一个地点，都会被公开吗？
  答：不会，只有最后一次的地点是公开的。

  问：我摇过的地点可以删除吗？
  答：可以，在“我的资料－>我的足迹”里可以删除摇过的地点。  

  问：聊天记录可以删除吗？
  答：可以，单句话长按删除，整个会话滑动删除。  
  
  问：碰到有变态骚扰怎么办？
  答：点击其头像后，然后把他拉黑。如果要脸脸协助处理，可以拉黑的同时举报。   

  问：我在脸脸的发言和发图会被公开到新浪微博吗？
  答：不会，除非是您明确分享到微博。  

  问：现场是什么意思？
  答：现场就是你当前所在的地点。
    EOF
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end
  
  def help_msg(from)
    str = <<-EOF   
  脸脸帮助：回复数字
  1、如何在脸脸中当上地主?
  2、遇见一位同城异性
  3、遇见一位同龄异性
  4、遇见一位国外异性
  5、遇见一位同城同性
  6、遇见一位同龄同性
  7、遇见一位国外同性
  ?、常见问题解答
  试试吧！
    EOF
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end

  def error_msg(from)
    Resque.enqueue(XmppMsg, $gfuid,from,"抱歉，出错了！")
  end

  def want_msg(from,to)
    gstr = to.gender==2? "美女" : "帅哥"
    str = "脸脸找到了一位#{gstr}: #{to.name}, #{City.city_name(to.city)}. 返回到'对话'中查看吧。"
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end

  $count=1
  def find_user(user,int)
    $count+=1
    skip = $count % 10
    case int
    when 2
      ck = User.where({city:user.city, gender:{"$ne" => user.gender}, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 3
      reg = Regexp::new("^#{user.birthday[0,4]}")
      ck = User.where({birthday:reg, gender:{"$ne" => user.gender}, auto:nil,invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 4
      ck = User.where({city:nil, gender:{"$ne" => user.gender}, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 5
      ck = User.where({city:user.city, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 6
      reg = Regexp::new("^#{user.birthday[0,4]}")
      ck = User.where({birthday:reg, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 7
      ck = User.where({city:nil, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    end
    return nil if (ck.nil? || ck.id.to_s==$gfuid || ck.id.to_s=="5032ef4e421aa91a1e00001f") #点世界id
    ck
  end

  def want(uid,int)
    user = User.find_by_id(uid)
    if user.nil?
      error_msg(uid)
    else
      to = find_user(user,int)
      if to.nil?
        error_msg(uid)
        return
      end
      want_msg(uid,to)
      Resque.enqueue(XmppMsg, to.id, uid, ": (此为系统消息，不是#{to.name}所发)")
    end
  end

    #预置问答的响应
  def pre_answer(msg, user, shop)
    ta = user.gender ==2 ? '他' : "她"
    xb = user.gender ==2 ? '男' : "女"
    us = shop.checkin_users
    attrs = " NOLOG='1' "
    ext = nil
    case msg
    when '0'
      text = shop.pre_faqs(user)
      return Xmpp.send_gchat2($gfuid,shop.id,user.id, text, "FAQ#{shop.id}#{user.id}#{Time.now.to_i}")
    when '01'
      return Xmpp.send_gchat2($gfuid,shop.id,user.id, "脸脸能优惠", "FAQ#{shop.id}#{user.id}#{Time.now.to_i}")
    when '02'
      attrs += " url='dface://scheme/near/user' " 
      ext = "<x xmlns='dface.url'>dface://scheme/near/user</x>"
      return Xmpp.send_gchat2($gfuid,shop.id,user.id, "热点用户", "FAQ#{shop.id}#{user.id}#{Time.now.to_i}", attrs, ext)
    when '03'
      return false if us.select{|m| m.gender != user.gender}.blank?
      text = "回复：@@@脸脸赐我#{xb}神"
      return Xmpp.send_gchat2($gfuid,shop.id,user.id, text, "FAQ#{shop.id}#{user.id}#{Time.now.to_i}")
    when "@@@脸脸赐我男神"
      
      sbu = us.select{|m| m.gender == 1}.sample(1).first
      return false if sbu.nil?
      attrs += " url='dface://scheme/user/info?id=#{sbu.id}' " 
      ext = "<x xmlns='dface.url'>dface://scheme/user/info?id=#{sbu.id}</x>"
      return Xmpp.send_gchat2($gfuid,shop.id,user.id, "男神信息", "FAQ#{shop.id}#{user.id}#{Time.now.to_i}", attrs, ext)
    when "@@@脸脸赐我女神"
     
     sbu = us.select{|m| m.gender == 2}.sample(1).first
     return false if sbu.nil?
     attrs += " url='dface://scheme/user/info?id=#{sbu.id}' " 
     ext = "<x xmlns='dface.url'>dface://scheme/user/info?id=#{sbu.id}</x>"
     return Xmpp.send_gchat2($gfuid,shop.id,user.id, "女神信息", "FAQ#{shop.id}#{user.id}#{Time.now.to_i}", attrs, ext)
    end
    return false
  end


end
