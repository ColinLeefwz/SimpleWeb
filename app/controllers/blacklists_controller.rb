class BlacklistsController < ApplicationController
  before_filter :user_login_filter #, :except => [:index]
  before_filter :user_is_session_user, :except => [:index]

  def index
    id = Moped::BSON::ObjectId(params[:id])
    users = UserBlack.where({uid:id}).map {|x| User.find_by_id(x["bid"]) }
    users.delete_if {|x| x.nil? } 
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users)
  end

  def create
    report = params[:report].to_i
    ub = UserBlack.new
    ub.uid = session[:user_id]
    ub.bid = Moped::BSON::ObjectId(params[:block_id])
    ub.report = report
    ub.save!
    ub.add_black_redis
    Resque.enqueue(XmppBlack, session[:user_id], params[:block_id], 'block')
    Resque.enqueue(XmppBlackNotice, session[:user_id], params[:block_id]) if report==1
    render:json => hash.to_json
  end

  def delete
    bid = Moped::BSON::ObjectId(params[:block_id])
    UserBlack.delete_all({uid:session[:user_id], bid:bid})
    UserBlack.del_black_redis(session[:user_id],bid)
    Resque.enqueue(XmppBlack, session[:user_id], params[:block_id], 'unblock')
    render :json => {:deleted => params[:block_id]}.to_json
  end
  
  
end
