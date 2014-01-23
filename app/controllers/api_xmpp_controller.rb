class ApiXmppController < ApplicationController

  def push_message
    if !to.blank? && !params[:msg].blank?
      if to.is_a? Array
        result = []
        to.each { |t| result << Resque.enqueue(XmppMsg, from, t, params[:msg])}
      else
        result = Resque.enqueue(XmppMsg, from, to, params[:msg])
      end
      render json: { error: 0, message: result }
    else
      render json: { error: 0, message: "noting to push" }
    end
  end

  private

    def from
      params[:from] || $gfuid
    end

    def to
      params[:to]
    end

end