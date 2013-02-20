# coding: utf-8

class AroundmeController < ApplicationController
  
  def shops
    arr = Shop.new.find_shops([params[:lat].to_f,params[:lng].to_f],
          params[:accuracy].to_f,real_ip,session[:user_id],params[:bssid])  
    hash = arr.map do |x|
      s = Shop.new(x)
      s.id = x["_id"].to_i
      s.safe_output_with_users
    end
    render :json =>  hash.to_json
  end
  
  def shop2
    (params[:user].nil? || params[:user]=="")? uid="": uid=User.find(params[:user].gsub(/\s+/, "")).id
    if params[:loc] && params[:loc].length>3
      lob = params[:loc].split(/[,]/).map { |m| m.to_f  }.reverse
      loc = Shop.lob_to_lo(lob)
      @shops = Shop.new.find_shops(loc,params[:accuracy].to_f,params[:ip],uid,nil,true)  
    elsif params[:lo]
      loc = params[:lo].split(/[,]/).map { |m| m.to_f  }
      @shops = Shop.new.find_shops(loc,params[:accuracy].to_f,params[:ip],uid,nil,true)
    else
      @shops = []
    end
  end
  
  def mapabc
    count = params[:count] || 100
    loc = Offset.offset(params[:lat].to_f , params[:lng].to_f)
    render :json =>  Mapabc.where({ loc: { "$within" => { "$center" => [loc, 0.003]} }}).limit(count).map {|s| s.safe_output_with_users}.to_json
  end
  
  def users
    ret = []
    users = User.where({pcount: {"$gt" => 2}}).limit(4)
    users.each {|u| ret << u.safe_output_with_relation(session[:user_id]) }
    if ret
      render :json => ret.to_json
    else
      render :json => [].to_json
    end
  end
  
  def hot_users
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    lo = [params[:lat].to_f , params[:lng].to_f]
    city = Shop.get_city(lo)
    if page%2==1
      sex = session_user.gender
      if sex==1
        sex=2
      else
        sex=1
      end
    else
      sex = session_user.gender
    end
    ckins = Checkin.where({city: city, sex:sex, sid:{"$ne" => 20325453}}).sort({_id:-1}).skip(skip).limit(pcount*10).to_a
    arr = ckins.uniq!{|x| x.uid}.map{|c| [c.user,c.shop]}
    if arr.nil?
      render :json => [].to_json
      return
    end
    users = []
    arr.each do |user,shop| 
      next if shop.nil?
      next if user.forbidden?
      next if user.block?(session[:user_id])
      hash = user.safe_output_with_relation(session[:user_id])
      hash.merge!({location: "@"+shop.name})
      users << hash
    end
    fm = users.group_by {|item| item["gender"]==2 ? "f" : "m" }
    fmf = fm["f"]
    fmf = [] if fmf.nil?
    fmm = fm["m"]
    fmm = [] if fmm.nil?
    render :json => fmf.concat(fmm).to_json
  end
  
  private 
  
  def user_to_score(uc)
    return uc*3 if(uc<=10) 
    return 75 if(uc>100) 
    return 30+(uc-10)/2
  end
  
end
