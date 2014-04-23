class EmailMessagesController < ApplicationController
  def new_share_message
    logger.info "new_share_message"
    @share_email_form = ShareEmailForm.new(params)
    respond_to do |format|
      format.js {}
    end
  end
end
