class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

	def enroll
		if user_signed_in?
			logger.info "enroll page"
			render nothing: true
		else
			redirect_to new_user_session_path
		end
		
		
	end
end

