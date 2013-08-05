# encoding: utf-8
class AdminUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

    hash = {}
    sort = {_id: -1}

    unless params[:name].blank?
      hash.merge!(name: /#{params[:name]}/i)
    end

    hash.merge!({id: params[:id]}) unless params[:id].blank?
    hash.merge!({wb_uid: params[:wb_uid]}) unless params[:wb_uid].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?
    hash.merge!({gender: params[:gender]}) unless params[:gender].blank?
    hash.merge!({birthday: params[:birthday]}) unless params[:birthday].blank?

    case params[:wb_v]
    when '1'
      hash.merge!({wb_v: true}) 
    end

    @users =  paginate3("User", params[:page], hash, sort)

  end

  def show
    @user = User.find(params[:id])
  end

  def logos
    user = User.find(params[:id])
    @logos = user.user_logos
  end

  def ajax_kx
    begin
      kxuser = KxUser.new(type: '脸脸')
      kxuser._id = params[:id].__mongoize_object_id__
      kxuser.save
    rescue
    end
    $redis.sadd("KxUsers", kxuser._id)
    render :nothing => true
  end

  def get_info
    user = User.find_by_id(params[:id])
    render :json => {'info' => user ? "#{user.name} #{user.show_gender}" : "找不到该用户."}
  end

  def follows
    user = User.find_by_id(params[:user_id])
    hash = {_id: {"$in" => user.follow_ids}}
    sort = {_id: -1}
    @users =  paginate3("User", params[:page], hash, sort)
    render :file => "/admin_users/index"
  end

  def blacks
    user = User.find_by_id(params[:user_id])
    hash = {_id: {"$in" => user.black_ids}}
    sort = {_id: -1}
    @users =  paginate3("User", params[:page], hash, sort)
    render :file => "/admin_users/index"
  end


  def chat
    @user = User.find_by_id(params[:id])
    chats = @user.chat.sort{|a,b| b[2] <=> a[2]}
    @chats = paginate_arr(chats, params[:page], 50)
  end

  def human_chat
    @user = User.find_by_id(params[:id])
    chats = @user.human_chat(params[:uid]).sort{|a,b| b[3] <=> a[3]}
    @chats =paginate_arr(chats, params[:page], 50 )
  end
  
  def kill
    user = User.find_by_id(params[:id])
    user_black = UserBlack.find(params[:ubid])
    user_black.update_attribute(:flag, true)
    user.kill
    render :text => "ok"
  end

  def kill2
    user = User.find_by_id(params[:id])
    user.kill
    render :text => "ok"
  end
  
  def unkill
    @user = User.find_by_id(params[:id])
    @user.password=Digest::SHA1.hexdigest(":dface#{@user.wb_uid}")[0,16]
    @user.head_logo_id=@user["logo_backup"]
    @user.save!
    render :text => "ok"
  end

  def prompt
    @user = find_by_id(params[:id])
    @user.prompt
  end

  def warn
    @user = find_by_id(params[:id])
    @user.warn2
  end

end

