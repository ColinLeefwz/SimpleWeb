class ApiShareController < ApplicationController
	def wbshare
		token = $redis.get("wbtoken#{params[:id]}")
		return render :json => 0 if token.blank?
		Resque.enqueue(WeiboPhoto, token, params[:str], params[:url])
		render :json => 1
	end

	def qqshare
		title = params[:title]
    	text = params[:str]
    	url = params[:url]
    	return render :json => 0 if $redis.get("qqtoken#{params[:id]}").blank?
		Resque.enqueue(QqPhoto, params[:id], title, text, url, nil, nil)
		render :json => 1
	end
end