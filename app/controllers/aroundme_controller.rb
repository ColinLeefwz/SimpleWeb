# coding: utf-8

class AroundmeController < ApplicationController
  
  def shops
    lo = [params[:lat].to_f,params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    arr = Shop.new.find_shops(lo,params[:accuracy].to_f,session[:user_id],params[:bssid])  
    hash = arr.map do |x|
      s = Shop.instantiate(x)
      s.safe_output_with_users
    end
    record_gps(lo)
    render :json =>  hash.to_json
  end

  def shop_report
    arr = Shop.new.find_shops([params[:lat].to_f,params[:lng].to_f],params[:accuracy].to_f,params[:uid],params[:bssid])
    @shops = arr.map do |x|
      [x['name'],x['_id'].to_i]
    end
    render :layout => false
  end

  def report
    ShopReport.create(:uid => params[:uid], :sid => params[:sid], :des => params[:des] )
    render :js => true
  end
  
  def shop2
    (params[:user].nil? || params[:user]=="")? uid="": uid=User.find_by_id(params[:user].gsub(/\s+/, "")).id
    if params[:loc] && params[:loc].length>3
      lob = params[:loc].split(/[,]/).map { |m| m.to_f  }.reverse
      loc = Shop.lob_to_lo(lob)
      @shops = Shop.new.find_shops(loc,params[:accuracy].to_f,uid,params[:bssid],true)  
    elsif params[:lo]
      loc = params[:lo].split(/[,]/).map { |m| m.to_f  }
      @shops = Shop.new.find_shops(loc,params[:accuracy].to_f,uid,params[:bssid],true)
    else
      @shops = []
    end
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
    ckins = Checkin.where({city: city, sex:sex, sid:{"$ne" => $llcf}}).sort({_id:-1}).skip(skip*2).limit(pcount*5).to_a
    if ckins.size==0
      ckins = Checkin.where({city: nil, sex:sex, sid:{"$ne" => $llcf}}).sort({_id:-1}).skip(skip*2).limit(pcount*5).to_a
    end
    #TODO: 缓存一个用户（在一个城市）的最后一次签到
    arr = ckins.uniq!{|x| x.uid}[0,pcount].map{|c| [c.user,c.shop,c.cati]}
    users = []
    arr.each do |user,shop,cati| 
      next if shop.nil?
      next if user.forbidden?
      next if user.block?(session[:user_id])
      next if user.id.to_s=="51145007c90d8b056a000796" #马甲Keri Choo	
      hash = user.safe_output_with_relation(session[:user_id])
      diff = Time.now.to_i - cati
      tstr = User.time_desc(diff)
      hash.merge!({location: "#{tstr} #{shop.name}"})
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
  
  def record_gps(lo)
    hash = {uid:session[:user_id], lo:lo, acc:params[:accuracy]}
    hash.merge!(bssid:params[:bssid]) if params[:bssid]
    hash.merge!(bd:params[:baidu]) if params[:baidu]
    GpsLog.collection.insert(hash)
  end
  
end
