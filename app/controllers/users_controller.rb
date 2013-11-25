class UsersController < ApplicationController
  def relationship
    respond_to do |format|
      format.js{
        the_followed_id = params[:the_followed]
				followed_user = User.find the_followed_id

        if current_user.try(:follow?, followed_user)
          current_user.unfollow(followed_user)
        else
          current_user.follow(followed_user)
        end

        render nothing: true
      }
    end
  end

  def following
  end

  def followers
  end

end
