class UsersController < ApplicationController

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

  def following
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

