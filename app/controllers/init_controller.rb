class InitController < ApplicationController
  def init
    hash = Digest::SHA1.hexdigest("#{params[:model]}#{params[:os]}#{params[:mac]}init")[0,32]
    if hash != params[:hash]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    logger.info "INIT: #{params[:model]} , #{params[:os]} , #{params[:mac]}"
    render :json => {ip: "60.191.119.190", xmpp:"60.191.119.190" }.to_json
  end
end
