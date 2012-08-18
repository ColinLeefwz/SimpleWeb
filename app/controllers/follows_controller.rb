class FollowsController < ApplicationController
  
  before_filter :user_is_session_user

  def create
    session_user.add_to_set(:follows, params[:follow_id])
    render:json => {:saved => params[:follow_id] }.to_json
  end

  def delete
    session_user.pull(:follows, params[:follow_id])
    render:json => {:deleted => params[:follow_id] }.to_json
  end
  
  

end
