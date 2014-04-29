class DashboardController < ApplicationController
  def dashboard
    @profile = current_user.profile
  end

  def settings
    @profile = current_user.profile
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def edit_profile
    @profile = current_user.profile
    respond_to do |format|
      format.js{
        render partial: 'dashboard/profile/edit'
      }
      format.html {}
    end
  end
end
