class UsersController < ApplicationController
  def follow
    respond_to do |format|
      format.js{
        the_followed = params[:the_followed_id]
        follower = current_user.try(:id)

        Following.create!(the_followed: the_followed, follower: follower)
        render nothing: true
      }
    end
  end

  def unfollow
  end

  def following
  end

  def followers
  end
end
