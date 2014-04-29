class UsersController < ApplicationController

  def validate_invite_email
    to_address = params[:to_address]

    user = User.find_by email: to_address

    error_message = ""
    flag = true

    if to_address.empty?
      error_message = "Email address can not be blank"
      flag = false
    elsif user
      error_message = "This email address has already been invited to Prodygia"
      flag = false
    end

    if flag
      render json: {status: true}
    else
      render json: { error_message: error_message, status: false }
    end
  end

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
        render partial: 'following', locals: {target: target}
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

end

