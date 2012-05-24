require 'mime/types'
class UserLogosController < ApplicationController
#  before_filter :user_authorize, :except => [:update]
  layout "user"

  def initialize
    @menu_tag_id = 1
    @menu_tag2_id = 6
  end

  def index
    render :json => {:aaa => 111}
  end

  def new
    @user_logo=UserLogo.find_by_user_id(session_user.id, :order => "id desc")
    if @user_logo.nil?
      @new=1
    else
      @new=0
    end
    @user_logo = UserLogo.new if @user_logo.nil?
  end

  def create
    @user_logo = UserLogo.new(:uploaded_data => params[:up_logo])
    @user_logo.user_id= 1
    if @user_logo.save
      render :js => "#{@user_logo.public_filename}"
    else
      render :action => :new
    end
  end

end
