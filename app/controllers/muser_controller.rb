class MuserController < ApplicationController
  def index
  end
  
  def login
    respond_to do |format|
      #debugger
      format.js {render :json => request.env['HTTP_USER_AGENT'].to_json}
    end
  end

  # 根据ID读取用户头像
  def logo
    @user = User.find_by_id(params[:id])
  end

  # 上传用户头像
  def upload_logo
    @user_logo = UserLogo.new(params[:user_logo])
    @user_logo.user_id = session_user.id
    if @user_logo.save
    end
  end

  # 更换用户头像
  def update_logo
      if @user_id && UserLogo.find_by_user_id(@user_id)
        UserLogo.delete_all(["user_id = ?", @user_id])
      end
  end

end
