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


  def subscribe
    respond_to do |format|
      format.js{
        type = params[:type]

        current_item = type.constantize.find(params[:item_id])

        if current_user.blank?
        else
          if current_user.has_subscribed?(current_item)
            current_user.unsubscribe(current_item)
          else
            current_user.subscribe(current_item)
          end
          render "shared/update_favorite_star"
        end
      }
    end
  end

end
