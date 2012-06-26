class FollowInfoController < ApplicationController
  
  
  def followers
    @followers = Follow.paginate(:conditions => genCondition(params[:id].to_i), :include => :user,:page => params[:page], :per_page => 20)
    @users = @followers.map {|x| x.user}
    puts_users(@users)
  end
  
  def friends
    @friends = Follow.paginate(:page => params[:page], :per_page => 20, :conditions => genCondition(params[:id].to_i), :include => :follow)
    @users = @friends.map {|x| x.follow}
    puts_users(@users)
  end
  
  private

  def genCondition(id)

    if params[:action] == "followers"
      sql = "follows.follow_id = ?"
      a = [id]
    elsif params[:action] == "friends"
      sql = "follows.user_id = ?"
      a = [id]
    end

    unless  params[:name].blank?
      sql += " and users.name like ? "
      a << "%#{params[:name]}%"
    end

    a.unshift(sql)

  end


  def puts_users(fs)
    users = []
    fs.each {|f| users << f.safe_output_with_relation(params[:id].to_i) } if fs
    if params[:hash]
      ret = {:count => fs.size}
      ret.merge!( {:data => users})
    else
      ret = [{:count => fs.size}]
      ret << {:data => users}
    end
    render :json => ret.to_json
  end

  def output_users(fs)
    users = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    
    fs2 = fs[(page-1)*pcount,pcount]
    fs2.each {|f| users << f.safe_output_with_relation(params[:id].to_i) } if fs2
    if params[:hash]
      ret = {:count => fs.size}
      ret.merge!( {:data => users})
    else
      ret = [{:count => fs.size}]
      ret << {:data => users}
    end
    render :json => ret.to_json
  end
  
  
end
