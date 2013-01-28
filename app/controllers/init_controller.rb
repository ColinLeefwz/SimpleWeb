class InitController < ApplicationController
  def init
    hash = Digest::SHA1.hexdigest("#{params[:model]}#{params[:os]}#{params[:mac]}init")[0,32]
    if params[:hash].nil? || hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    logger.info "INIT: #{params[:model]} , #{params[:os]} , #{params[:mac]}, #{params[:ver]}"
		#ip = "192.168.244.4" if real_ip=="58.100.92.146"
    render :json => {ip: $web_ip, xmpp: $xmpp_ip , ver:1.2}.to_json
  end
end
