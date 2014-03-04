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
      #TODO: Peter at 2014-03-02: redirect or show something
      # send email to Admin account
      # set this consultation's status to "pending"
      respond_to do |format|
        format.js {  }
      end
    end
  end

  private
  def consultation_params
    params.require(:consultation).permit(:id, :requester_id, :consultant_id, :description)
  end
end
