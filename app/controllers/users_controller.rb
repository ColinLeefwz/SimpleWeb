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

  # private
  # def unfollow(the_followed)
  #   # relation = Following.find_by(the_followed: the_followed, follower: current_user.id)
  #   # relation.destroy
		# User.find(the_followed).followers.delete current_user
  # end

  # def follow(the_followed)
  #   # relation = Following.create(the_followed: the_followed, follower: current_user.id)
		# User.find(the_followed).followers << current_user
  # end
end
