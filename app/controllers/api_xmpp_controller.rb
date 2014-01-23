class ApiXmppController < ApplicationController
  layout nil

  def push_message
    return if to.blank? || params[:msg].blank?
    if to.is_a? Array
      to.each { |t| Resque.enqueue(XmppMsg, from, t, params[:msg])}
    else
      Resque.enqueue(XmppMsg, from, to, params[:msg])
    end 
    render json: { error: 0 }
  end

  private

    def from
      params[:from] || $gfuid
    end

    def to
      params[:to]
    end

end