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

end
