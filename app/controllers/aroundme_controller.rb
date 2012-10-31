class AroundmeController < ApplicationController
  
  def shops
    uid = ",ObjectId('#{session[:user_id]}')" if session[:user_id]
    str = "find_shops([#{params[:lat]},#{params[:lng]}],#{params[:accuracy]},'#{real_ip}'#{uid})"
    arr = Mongoid.default_session.command(eval:str)["retval"]
    if arr[0].class == Array #[商家、距离+评分、评分]
      arr.each {|x| puts "#{x[1]},  #{x[2]},    #{x[0]["name"]}"}
      realtime_score = arr.map {|x| user_to_score( Checkin.get_users_count_redis(x[0]["_id"]) )}
      arr.each_with_index {|x,i| x[1] -= realtime_score[i]}
      arr.sort! {|a,b| a[1] <=> b[1]}
      arr = arr.map {|x| x[0]}
    end    
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
