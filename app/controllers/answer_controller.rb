# coding: utf-8

class AnswerController < ApplicationController

  layout nil
  
  def shop
    sid = params["sid"]
    uid = params["uid"]
    msg = params["msg"]
    Xmpp.send_gchat2(uid,sid,uid,msg)
    if sid=="20325453"
      Xmpp.send_gchat2($gfuid,sid,uid,"欢迎！")
    end
    render :text => "1"
  end
  
  def admin
    uid = params["uid"]
    txt = params["msg"]
    int = txt.to_i
    if int==1
      msg1(uid)
      msg2(uid)
    elsif  txt=="0" || txt=="o"
      msg3(uid)
    elsif  (int>1 && int<8)
      want(uid,int)
    else
      help_msg(uid)
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
    Resque.enqueue_in(5.seconds, XmppMsg, $gfuid,from,str)
  end

  def msg3(from)
    str = <<-EOF   
  试试：
  回复2、遇见一位同城异性
  回复3、遇见一位国内异性
  回复4、遇见一位国外异性
    EOF
    Resque.enqueue(XmppMsg, $gfuid,from,str)
  end

  def help_msg(from)
    str = <<-EOF   
  脸脸帮助：回复
  1、如何成为脸脸种子用户?
  2、遇见一位同城异性
  3、遇见一位国内异性
  4、遇见一位国外异性
  5、遇见一位同城同性
  6、遇见一位国内同性
  7、遇见一位国外同性
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
      ck = User.where({city:{"$ne" => user.city}, gender:{"$ne" => user.gender}, auto:nil,invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 4
      ck = User.where({city:nil, gender:{"$ne" => user.gender}, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 5
      ck = User.where({city:user.city, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
    when 6
      ck = User.where({city:{"$ne" => user.city}, gender: user.gender, auto:nil, invisible:{"$in" => [0,nil]} }).sort({_id:-1}).skip(skip).first
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
