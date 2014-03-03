class ConsultationsController < ApplicationController
  def new
    @consultation = Consultation.new(consultant: Expert.find(params[:expert]), requester: current_user)
    respond_to do |format|
      format.js { render 'new_consultation' }
    end

  end

  def create
    @consultation = Consultation.new consultation_params
    if @consultation.save
      #TODO: Peter at 2014-03-02: redirect or show something
      logger.info "created a new consultation"
    end
  end

  private
  def consultation_params
    params.require(:consultation).permit(:id, :requester_id, :consultant_id, :description)
  end
end
