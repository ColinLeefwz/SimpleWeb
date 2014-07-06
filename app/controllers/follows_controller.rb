# coding: utf-8

class FollowsController < ApplicationController
  before_filter :user_login_filter
  before_filter :user_is_session_user, :except => [:recommend ]

  def create
    UserFollow.add(session[:user_id], Moped::BSON::ObjectId(params[:follow_id]))
    Resque.enqueue(FollowNotice, session[:user_id], params[:follow_id] )
    render:json => {:saved => params[:follow_id] }.to_json
  end

  def delete
    UserFollow.del(session[:user_id], Moped::BSON::ObjectId(params[:follow_id]))
    render:json => {:deleted => params[:follow_id] }.to_json
  end
  
  def recommend
    user = User.find_by_id(params[:uid])
    unless user
      render :json => {"error" => "#{params[:uid]} not found."}.to_json
      return
    end
    #TODO: 检查params[:fid]在自己的好友列表中
    #TODO: 保存数据库记录UserRecommend
    #Resque.enqueue(XmppMsg, session[:user_id], params[:fid], ": 推荐一个用户#{desc}")
    str = "[img:Logo#{user.head_logo_id}:#{params[:uid]}]"
    Resque.enqueue(XmppMsg, session[:user_id], params[:fid], str, params[:mid])
    render :json => {"success" => params[:mid] }.to_json
  end
  

end
