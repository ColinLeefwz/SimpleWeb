class UsersController < ApplicationController
<<<<<<< HEAD

  def validate_user_name
    user_name = params[:user_name].parameterize
    duplication = User.user_name_duplicated?(user_name)
    render partial: 'dashboard/profile/validate_user_name', locals: {duplication: duplication}
  end


  def following
    target = User.find params[:target_id]

    user_following = UserFollowing.new(current_user, target)
    user_following.toggle
    respond_to do |format|
      format.js{
        render 'following', locals: {target: target}
      }
    end
  end

  def change_email
    respond_to do |format|
      format.js{
        current_user.update_attributes(email_params)
        flash[:success] = "Your email address has been updated"
        if current_user.is_a? Expert
          render js: "window.location='#{dashboard_expert_path(current_user.reload)}'"
        else
          render js: "window.location='#{dashboard_member_path(current_user.reload)}'"
        end
      }
    end

  end

  def favorite
    type = params[:item_type].classify.constantize
    target = type.find params[:item_id]

    favor = UserFavorite.new(current_user, target)
    favor.toggle
    respond_to do |format|
      format.js{
        render partial: 'favorite', locals: {target: target}
      }
    end
  end

  def email_params
    params.require(:user).permit(:email)
  end
end

=======
  before_filter :admin_authorize
  layout "admin"

  # GET /users
  # GET /users.xml
  def index
    # @users = User.paginate :all,:page => params[:page]
    @users = User.paginate(:conditions => genCondition, :joins => genJoins, :order => genOrder, :page => params[:page], :per_page =>20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.js
    end
  end

  def upgrade_to_shop
    @user = User.find(params[:id])
    s = @user.upgrade_to_shop
    render :text => "ok"
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  private
  def genCondition
    s = ""
    ad = ""
    h = Hash.new
    if has_value params[:id]
      s << ad
      s << "id = :id"
      h[:id] = "#{params[:id]}"
      ad = " and"
    end
    if has_value params[:phone]
      s << ad
      s << " phone like :phone"
      h[:phone] = "%#{params[:phone]}%"
      ad = " and"
    end
    if has_value params[:name]
      s << ad
      s << " name like :name"
      h[:name] = "%#{params[:name]}%"
      ad = " and"
    end
    if has_value params[:score]
      s << ad
      s << " score = :score"
      h[:score] = "#{params[:score]}"
      ad = " and"
    end
    if has_value params[:email]
      s << ad
      s << " email like :email"
      h[:email] = "%#{params[:email]}%"
      ad = " and"
    end
    if has_value params[:sex]
      s << ad
      s << " sex = :sex"
      h[:sex] = "#{params[:sex]}"
      ad = " and"
    end
    if has_value params[:occupation]
      s << ad
      s << " occupation like :occupation"
      h[:occupation] = "%#{params[:occupation]}%"
    end
    if has_value params[:created_at]
      s << ad
      s << " created_at >= :created_at"
      h[:created_at] = "#{params[:created_at]}"
      ad = " and"
    end
    [s, h]
  end


  def genJoins
    s = []
    if has_value(params[:username])
      # s << " inner join users on consumptions.user_id = users.id"
    end
    s
  end

  def genOrder
    s =" id desc"
  end

end
>>>>>>> b8c272e31d97492bb030400d7034cb2d7a03ce34
