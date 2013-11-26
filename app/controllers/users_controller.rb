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

  def subscribe_session
    respond_to do |format|
     format.js{
       current_session = Session.where(id: params[:session_id]).first
       if current_user.has_subscribed?(current_session)
         current_user.unsubscribe(current_session)
       else
         current_user.subscribe(current_session)
       end

       render nothing: true
     } 
    end
  end

end
