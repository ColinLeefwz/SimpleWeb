class UsersController < ApplicationController
  def relationship
    respond_to do |format|
      format.js{
        the_followed = params[:the_followed]

        if current_user.try(:follow?, the_followed)
          unfollow(the_followed)
        else
          follow(the_followed)
        end

        render nothing: true
      }
    end
  end

  def following
  end

  def followers
  end

  private
  def unfollow(the_followed)
    relation = Following.find_by(the_followed: the_followed, follower: current_user.id)
    relation.destroy
  end

  def follow(the_followed)
    relation = Following.create(the_followed: the_followed, follower: current_user.id)
  end
end
