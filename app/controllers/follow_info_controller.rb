class FollowInfoController < ApplicationController
  
  
  def followers
    output_users Follow.find_all_by_follow_id(params[:id]).map {|x| x.user}
    
  end
  
  def friends
    output_users Follow.find_all_by_user_id(params[:id]).map {|x| x.follow}
  end
  
  private 
  def output_users(fs)
    users = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    fs2 = fs[(page-1)*pcount,pcount]
    fs2.each {|f| users << f.safe_output } if fs2
    ret = {:count => fs.size}
    ret.merge!( {:data => users})
    render :json => ret.to_json
  end
  
  
end
