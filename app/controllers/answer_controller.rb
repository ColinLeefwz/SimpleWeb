# coding: utf-8

class AnswerController < ApplicationController

  layout nil
  
  def shop
    sid = params["sid"]
    uid = params["uid"]
    msg = params["msg"]
    mid = params["mid"]    
    Xmpp.send_gchat2(uid,sid,uid,msg,mid)
    shop = Shop.find_by_id(sid)
    text = shop.answer_text(msg)
    @text = text if ENV["RAILS_ENV"] == "test"
    Xmpp.send_gchat2($gfuid,sid,uid, text) if text
    render :text => "1"
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
    elsif txt.downcase=="hi"
      Resque.enqueue_in(3.seconds,XmppMsg, $gfuid,uid,"hi😄")
    elsif txt=="您好" || txt=="你好"
      Resque.enqueue_in(3.seconds,XmppMsg, $gfuid,uid,"您好😄")
    elsif txt=="你是" || txt[0,3]=="你是谁"
      Resque.enqueue_in(5.seconds,XmppMsg, $gfuid,uid,"我是脸脸客服😊")
    elsif txt.bytesize==4
      Resque.enqueue_in(2.seconds,XmppMsg, $gfuid,uid,"😊")
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
  成为脸脸种子用户要求：
  1、一个月内摇进10个现场以上
  2、分享10张现场图片到新浪微博
  3、邀请好友三个以上
    EOF
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end

  def msg2(from)
    str = <<-EOF   
  你将获得：
  1、脸脸种子勋章一枚，彰显大姐大/大哥大身份
  2、优先享受脸脸最新优惠活动
  赶快行动吧！
    EOF
    Resque.enqueue_in(4.seconds, XmppMsg, $gfuid,from,str)
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
  答：不会，除非是您明确点击分享到微博。  

  问：现场是什么意思？
  答：现场就是你当前所在的地点。
    EOF
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end
  
  def help_msg(from)
    str = <<-EOF   
  脸脸帮助：回复
  1、如何成为脸脸种子用户?
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


end
