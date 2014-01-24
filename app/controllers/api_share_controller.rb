class ApiShareController < ApplicationController
	def wbshare
		token = $redis.get("wbtoken#{params[:id]}")
		return render :json => 0 if token.blank?
		Resque.enqueue(WeiboPhoto, token, params[:str], params[:url])
		render :json => 1
	end

	def qqshare
		title = params[:title]
    	desc = params[:desc]
    	url = params[:url]
    	img_url = params[:img_url]
    	return render :json => 0 if $redis.get("qqtoken#{params[:id]}").blank?
		Resque.enqueue(QqPhoto, params[:id], title, desc, url, desc, img_url)
		render :json => 1
	end
end