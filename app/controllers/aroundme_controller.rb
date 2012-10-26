class AroundmeController < ApplicationController
  
  def shops
    uid = ",ObjectId('#{session[:user_id]}')" if session[:user_id]
    str = "find_shops([#{params[:lat]},#{params[:lng]}],#{params[:accuracy]},'#{real_ip}'#{uid})"
    arr = Mongoid.default_session.command(eval:str)["retval"]
    hash = arr.map do |x|
      s = Shop.new(x)
      s.id = x["_id"].to_i
      s.safe_output_with_users
    end
    render :json =>  hash.to_json
  end
  
  def mapabc
    count = params[:count] || 100
    loc = Offset.offset(params[:lat].to_f , params[:lng].to_f)
    render :json =>  Mapabc.where({ loc: { "$within" => { "$center" => [loc, 0.003]} }}).limit(count).map {|s| s.safe_output_with_users}.to_json
  end
  
  def users
    ret = []
    User.where({name: {"$exists" => 1}}).sort({_id:-1}).limit(5).each {|u| ret << u.safe_output_with_relation(session[:user_id]) unless u.head_logo.nil?}
    if ret
      render :json => ret.to_json
    else
      render :json => [].to_json
    end
  end
  
end
