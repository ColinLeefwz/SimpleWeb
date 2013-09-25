class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

	def enroll
		@session = Session.find params[:id]
	end
end

