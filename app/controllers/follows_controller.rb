class FollowsController < ApplicationController
  before_filter :user_login_filter
  before_filter :user_is_session_user

  def create
    UserFollow.add(session[:user_id], Moped::BSON::ObjectId(params[:follow_id]))
    Resque.enqueue(FollowNotice, session[:user_id], params[:follow_id] )
    render:json => {:saved => params[:follow_id] }.to_json
  end

  def delete
    UserFollow.del(session[:user_id], Moped::BSON::ObjectId(params[:follow_id]))
    render:json => {:deleted => params[:follow_id] }.to_json
  end
  
  

end
