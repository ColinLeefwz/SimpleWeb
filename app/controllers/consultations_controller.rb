require "mandrill_api"

class ConsultationsController < ApplicationController
  def new
    @consultation = Consultation.new(consultant: Expert.find(params[:expert]), requester: current_user)
    respond_to do |format|
      if current_user.blank?
        @show_modal = 'shared/sign_in_modal'
        @alert_message = "Please log in to send the private consultation"
      else
        @show_modal = 'consultations/consultation_modal'
      end
      format.js { render 'new_consultation' }
    end

  end

  def create
    @consultation = Consultation.new consultation_params
    @consultation.status = Consultation::STATUS[:pending]
    if @consultation.save
      send_consultation_pending_mail
      respond_to do |format|
        format.js {  }
      end
    end
  end

  def accept
    @consultation = Consultation.find params[:id]
    @consultation.update_attributes status: Consultation::STATUS[:accepted]
    respond_to do |format|
      format.js { render "accept_or_reject" }
    end
  end

  private
  def consultation_params
    params.require(:consultation).permit(:id, :requester_id, :consultant_id, :description)
  end

  def send_consultation_pending_mail
    MandrillApi.new.consultation_pending_mail(@consultation)
  end
end
