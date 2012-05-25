require 'mime/types'
class UserLogosController < ApplicationController
  before_filter :user_authorize, :except => [:update]
  layout "user"

  def initialize
    @menu_tag_id = 1
    @menu_tag2_id = 6
  end

  def index
    @user_logo = UserLogo.find_by_user_id(session_user.id, :order => "id desc")
    @user_logo = UserLogo.new unless @user_logo
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
    @user_logo = UserLogo.new(params[:user_logo])
    @user_logo.user_id=params[:user_id]
    if @user_logo.save
      flash[:notice] = 'User Logo was successfully created.'
      redirect_to(:action => "index", :menu_id => params[:menu_id])
    else
      render :action => :new
    end
  end
end