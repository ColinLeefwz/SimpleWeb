class DashboardController < ApplicationController
  def dashboard
    @user = current_user
    @profile = @user.profile
  end

  def settings
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end
end
