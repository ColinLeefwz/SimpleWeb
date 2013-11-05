# coding: utf-8

class CouponsController < ApplicationController
  before_filter :user_login_filter, :only => [:list, :use, :delete]
  before_filter :user_is_session_user, :only => [:list, :delete]

  def img
    cpd = CouponDown.find(params[:id][0,24])
    cp = cpd.coupon
    if cpd.uid != session[:user_id]
      render :json => {error: "你没有获取到过这张优惠券"}.to_json
      return
    end
    gen_seq = params[:seq].to_s!="1"
    if cp.t2==2 && cp.img.url.nil?
      path = cpd.gen_share_coupon_img(gen_seq)
      redirect_to path
      return
    end
    if cp.t2==1 && cp.num && cpd.num && gen_seq
      path = cpd.gen_tmp_checkin_coupon_img
      redirect_to path
      return
    end
    if params[:size].to_i==0
      redirect_to cp.img.url
    else
      redirect_to cp.img.url(:t1)
    end
  end

  def delivered
    cp = CouponDown.find(params[:id][0,24])
    cp.update_attribute(:sat, Time.now) unless cp.sat
    render :json => {recv: params[:id]}.to_json
  end

  def displayed
    cp = CouponDown.find(params[:id][0,24])
    cp.update_attribute(:vat, Time.now) unless cp.vat
    render :json => {display: params[:id]}.to_json
  end
      
  def use
    coupon_down = CouponDown.find(params[:id][0,24])
    coupon_down.use(session[:user_id],params[:data],params[:sid])
    unless ShopMark.where({sid: coupon_down.sid, uid:  session[:user_id]}).limit(1).first
      $redis.smembers("GROUP#{session[:user_id]}").reverse.each do |gid|
        group = Shop.find_by_id(gid).group
        if ( group && line = group.line)
          if line.partners.to_a.flatten.include?(coupon_down.sid.to_s)
            Xmpp.send_chat($gfuid, session[:user_id], "你在#{coupon_down.shop_name}使用了一张优惠券，体验如何点击下面的链接给个评分吧:http://www.dface.cn/shop_marks/new?sid=#{coupon_down.sid}&uid=#{session[:user_id]}&gid=#{group.id}")
            break
          end
        end
      end
    end
    render :json => {used: params[:id]}.to_json
  end
  
  def list
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 10 if pcount==0
    skip = (page-1)*pcount
    st = params[:status].to_i
    hash = {uid: session[:user_id], del:{"$exists" => false}}
    if st==0
      hash.merge!({"$or" => [{st:8}, {st:{"$exists" => false}}] })
    elsif st==1
      hash.merge!({st:{"$exists" => false}})
    else
      hash.merge!({st: st})
    end
    if st==2
      sort_hash = {uat: -1}
    else
      sort_hash = {dat: -1}
      #TODO: 默认按时间排序,最新的在最前面。相同时间同一批收到的优惠券,按距离排序。
      #当前所在商家的优惠券自动置顶。
    end
    cds = CouponDown.where(hash).sort(sort_hash).skip(skip).limit(pcount)
    render :json => cds.map {|p| p.output_hash }.to_json
  end
  
  def delete
    begin
      cpd = CouponDown.find(params[:id])
    rescue
      Xmpp.error_notify("#{session_user.name}:试图删除不存在的优惠券:#{params[:id]}")
      render :json => {:deleted => params[:id]}.to_json
      return
    end
    if cpd.uid != session[:user_id]
      Xmpp.error_notify("#{session_user.name}: 优惠券用户id#{cpd.uid} != #{session[:user_id]}")
      render :json => {:error => "删除优惠券出错"}.to_json
      return
    end
    cpd.set(:del,true)
    render:json => {:deleted => params[:id] }.to_json
  end
  
  def batch_delete
    hash = params[:ids].split(",").map do |id|
      cpd = CouponDown.find_by_id(id)
      if cpd.nil? || cpd.uid != session[:user_id]
        {"#{id}" => "0"}
      else
        cpd.set(:del,true)
        {"#{id}" => "1"}
      end
    end
    render :json => hash.to_json
  end
  
  def batch_use
    hash = params[:infos].split(",").map do |info|
      arr = info.split("-")
      id = arr[0]
      cpd = CouponDown.find_by_id(id)
      if cpd.nil? || cpd.uid != session[:user_id]
        {"#{id}" => "0"}
      else
        cpd.use(session[:user_id],arr[2],arr[1])
        {"#{id}" => "1"}
      end
    end
    render :json => hash.to_json
  end
  
  #deprecated
  def info
    hash = params[:ids].split(",").map do |id|
      cd = CouponDown.find_by_id(id)
      #raise "优惠券拥有者错误" if cd.uid != session[:user_id]
      shop = cd.shop
      {id:id, loc: shop.loc_first}
    end
    render :json => hash.to_json
  end
  
end
