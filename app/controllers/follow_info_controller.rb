class FollowInfoController < ApplicationController
  
  
  def followers
    hash = {follows: Moped::BSON::ObjectId(params[:id])}
    hash.merge!({name: /#{params[:name]}/})  unless params[:name].nil?
    users = User.where(hash)
    output_users(users)
  end
  
  def friends
    users = User.find(params[:id]).follows.map {|x| User.where({_id:x}).first }
    users.delete(nil)
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users)
  end
  
  private

  def output_users(fs)
    users = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    
    fs2 = fs[(page-1)*pcount,pcount]
    fs2.each {|f| users << f.safe_output_with_relation(params[:id]) } if fs2
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
