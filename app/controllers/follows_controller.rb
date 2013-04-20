class FollowsController < ApplicationController
  before_filter :user_login_filter
  before_filter :user_is_session_user

  def create
    user = session_user_no_cache
    uf = UserFollow.find_or_new(user.id)
    uf.add_to_set(:follows, Moped::BSON::ObjectId(params[:follow_id]))
    uf.del_my_cache
    Rails.cache.delete("UI#{params[:follow_id]}#{session[:user_id]}"
    loc = user.last_loc
    Resque.enqueue(FollowNotice, user, params[:follow_id], loc.nil?? "" : Shop.find_by_id(loc.sid).name )
    render:json => {:saved => params[:follow_id] }.to_json
  end

  def delete
    uf = UserFollow.find(session[:user_id])
    uf.pull(:follows, Moped::BSON::ObjectId(params[:follow_id]))
    uf.del_my_cache
    Rails.cache.delete("UI#{params[:follow_id]}#{session[:user_id]}"
    render:json => {:deleted => params[:follow_id] }.to_json
  end
  
  

end
