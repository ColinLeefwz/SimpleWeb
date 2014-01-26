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

  def relationship
    respond_to do |format|
      format.js{
        the_followed_id = params[:the_followed]
				followed_user = User.find the_followed_id
        
        if current_user.blank?
          render js: "window.location='#{new_user_session_path}'"
          flash[:alert] = "Sorry! You have to sign in to follow an Expert"
        else
          if current_user.try(:follow?, followed_user)
            current_user.unfollow(followed_user)
          else
            current_user.follow(followed_user)
          end
          render "shared/update_favorite_star"
        end
      }
    end
  end

  def following
  end

  def followers
  end

	## Peter at 2014-01-24: this action and "subscribe_video_interview" can be refactor together
  def subscribe
    respond_to do |format|
      format.js{
				type = params[:type]

				current_item = type.constantize.find(params[:item_id])

        if current_user.blank?
          render js: "window.location='#{new_user_session_path}'"
          flash[:alert] = "Sorry! You have to sign in to follow #{decide_item_type(current_item)}"
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

  private 
  def decide_item_type(item)
    if item.is_a? ArticleSession
     "an Article" 
    elsif item.is_a? Course
      "a Course"
    elsif item.is_a? VideoInterview
      "a Video interview"
    end
  end
end
