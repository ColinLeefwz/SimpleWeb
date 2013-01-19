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
    # TODO: 综合考虑位置（城市）、性别、头像质量等.可以考虑通过管理后台来设置。
    ret = []
    users = User.where({pcount: {"$gt" => 0}}).limit(10)
    users.sort! {|a,b| b.pcount <=> a.pcount}
    users[0,4].each {|u| ret << u.safe_output_with_relation(session[:user_id]) }
    if ret
      render :json => ret.to_json
    else
      render :json => [].to_json
    end
  end
  
  private 
  
  def user_to_score(uc)
    return uc*3 if(uc<=10) 
    return 75 if(uc>100) 
    return 30+(uc-10)/2
  end
  
end
