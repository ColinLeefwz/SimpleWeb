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

  def subscribe_session
    respond_to do |format|
      format.js{
        current_session = Session.where(id: params[:session_id]).first
        if current_user.blank?
          render js: "window.location='#{new_user_session_path}'"
          flash[:alert] = "Sorry! You have to sign in to follow an Article"
        else
          if current_user.has_subscribed?(current_session)
            current_user.unsubscribe(current_session)
          else
            current_user.subscribe(current_session)
          end
          render "shared/update_favorite_star"
        end
     } 
    end
  end

  def subscribe_course
    respond_to do |format|
      format.js{
        current_course = Course.where(id: params[:course_id]).first
        if current_user.blank?
          render js: "window.location='#{new_user_session_path}'"
          flash[:alert] = "Sorry! You have to sign in to follow a Course"
        else
          if current_user.has_subscribed?(current_course)
            current_user.unsubscribe(current_course)
          else
            current_user.subscribe(current_course)
          end
          render "shared/update_favorite_star"
        end
     } 
    end
  end

  def subscribe_video_interview
    respond_to do |format|
      format.js{
        video_interview = VideoInterview.where(id: params[:video_interview_id]).first
        if current_user.blank?
          render js: "window.location='#{new_user_session_path}'"
          flash[:alert] = "Sorry! You have to sign in to follow a Video Interview"
        else
          if current_user.has_subscribed?(video_interview)
            current_user.unsubscribe(video_interview)
          else
            current_user.subscribe(video_interview)
          end
          render "shared/update_favorite_star"
        end
     } 
    end
  end

end
