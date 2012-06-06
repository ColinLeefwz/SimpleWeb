class FollowInfoController < ApplicationController
  
  
  def followers
    output_users Follow.find_all_by_follow_id(params[:id])
    
  end
  
  def friends
    output_users Follow.find_all_by_user_id(params[:id])
  end
  
  private 
  def output_users(fs)
    ret = []
    page = params[:page] || 1
    pcount = params[:pcount] || 50
    page = page.to_i
    pcount = pcount.to_i
    fs2 = fs[(page-1)*pcount,pcount]
    fs2.each {|f| ret << f.user.safe_output } if fs2
    ret << {:count => fs.size}
    render :json => ret.to_json
  end
  
  
end
