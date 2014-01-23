class ApiXmppController < ApplicationController

  def push_message
    return if to.blank? || params[:msg].blank?
    if to.is_a? Array
      to.each { |t| XmppMsg.perform(from, t, params[:msg]) }
    else
      XmppMsg.perform(from, to, params[:msg])
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