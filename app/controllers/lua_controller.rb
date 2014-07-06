class LuaController < ApplicationController
  
  def callback
    Rails.logger.warn params.to_json
    render :text => "ok"
  end
  
end
