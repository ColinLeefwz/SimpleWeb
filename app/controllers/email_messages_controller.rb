class EmailMessagesController < ApplicationController
  def new_share_message
    @share_email_form = ShareEmailForm.new(email_params, current_user)
    respond_to do |format|
      format.js {}
    end
  end

  def send_share_email
    @share_email_form = ShareEmailForm.new(params[:share_email_form], current_user)
    if @share_email_form.submit(params[:share_email_form])
      respond_to do |format|
        format.js {}
      end
    end
  end

  private
  def email_params
    params
  end
end
