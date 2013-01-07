class FollowsController < ApplicationController
  before_filter :user_login_filter
  before_filter :user_is_session_user

  def create
    session_user.add_to_set(:follows, Moped::BSON::ObjectId(params[:follow_id]))
    loc = session_user.last_loc
    Resque.enqueue(FollowNotice, session_user, params[:follow_id], loc.nil?? "" : Shop.find(loc.sid).name )
    render:json => {:saved => params[:follow_id] }.to_json
  end

  def delete
    session_user.pull(:follows, Moped::BSON::ObjectId(params[:follow_id]))
    render:json => {:deleted => params[:follow_id] }.to_json
  end
  
  

end
