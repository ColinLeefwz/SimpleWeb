class EmailMessagesController < ApplicationController
  def new_share_message
    @share_email_form = ShareEmailForm.new(current_user).init_new_form(params)
    respond_to do |format|
      format.js {}
    end
  end

  def send_share_email
    @share_email_form = ShareEmailForm.new(current_user).create_form(params)

    if @share_email_form.submit
      respond_to do |format|
        format.js {}
      end
    end
  end

  def new_refer_message
    @refer_email_form = ReferEmailForm.new(params)
    respond_to do |format|
      format.js {}
    end
  end

  def validate_invite_email
    ## Peter at 2014-04-24: these code should be extracted to EmailMessage.validate_invite_email
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

  private
  def email_params
    params
  end
end
