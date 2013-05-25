class AcraController < ApplicationController
  
  def create
    CrashLog.collection.insert(request.params.as_json)
    render :text => "ok"
  end
end
