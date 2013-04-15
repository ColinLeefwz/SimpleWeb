class InitController < ApplicationController
  def init
    hash = Digest::SHA1.hexdigest("#{params[:model]}#{params[:os]}#{params[:mac]}init")[0,32]
    if params[:hash].nil? || hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    logger.info "INIT: #{params[:model]} , #{params[:os]} , #{params[:mac]}, #{params[:ver]}"
    session[:ver]=params[:ver]
    if "502e6303421aa918ba000001" == session[:user_id].to_s
      ip = $web_ips[2]
    else
      ip = $web_ip
    end
    if params[:os][0,7].downcase=="android"
      ver = 1.41
    else
      ver = 1.4
    end
    render :json => {ip: ip, xmpp: $xmpp_ip , ver:ver }.to_json
  end
end
