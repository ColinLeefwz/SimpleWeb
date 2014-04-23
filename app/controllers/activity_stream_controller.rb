class ActivityStreamController < ApplicationController
  def show
    stream = ActivityStream.find(params[:id])
    @activities = stream.activities
    respond_to do |format|
      format.js{}
    end
  end
end
