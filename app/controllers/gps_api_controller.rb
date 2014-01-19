class GpsApiController < ApplicationController
	def lo_to_lob
		raise if params[:lng].blank? || params[:lat].blank?
		render :json => Shop.lo_to_lob([params[:lat].to_f, params[:lng].to_f]).to_json
	end
end