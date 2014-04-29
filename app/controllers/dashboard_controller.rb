class DashboardController < ApplicationController
  def dashboard
    @user = current_user
    @profile = @user.profile
  end
end
