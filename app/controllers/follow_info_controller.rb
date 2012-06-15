class FollowInfoController < ApplicationController
  
  
  def followers
    output_users Follow.find(:all, :conditions => genCondition(params[:id].to_i), :include => :user)
  end
  
  def friends
    output_users Follow.find(:all, :conditions => genCondition(params[:id].to_i), :include => :follow)
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

    #    puts "------------------|#{a.unshift(sql.join(" and "))}|"
    a.unshift(sql)

  end

  def output_users(fs)
    puts "------------------------------------|#{fs.length}|"
    users = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    
    fs2 = fs[(page-1)*pcount,pcount]
    fs2.each {|f| users << f.user.safe_output } if fs2
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
