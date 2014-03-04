require "mandrill_api"

class ConsultationsController < ApplicationController
  def new
    @consultation = Consultation.new(consultant: Expert.find(params[:expert]), requester: current_user)
    respond_to do |format|
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

  private
  def consultation_params
    params.require(:consultation).permit(:id, :requester_id, :consultant_id, :description)
  end

  def send_consultation_pending_mail
    MandrillApi.new.consultation_pending_mail(@consultation)
  end
end
