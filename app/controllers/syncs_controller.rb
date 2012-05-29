require 'rexml/document'
include REXML
require 'json'

class SyncsController < ApplicationController

  # before_filter :login_required

  def sina_new
    client = OauthChina::Sina.new
    authorize_url = client.authorize_url
    Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
    redirect_to authorize_url
  end

  def sina_callback
    client = OauthChina::Sina.load(Rails.cache.read(build_oauth_token_key("sina", params[:oauth_token])))
    client.authorize(:oauth_verifier => params[:oauth_verifier])

    results = client.dump

    if results[:access_token] && results[:access_token_secret]
      #下次使用的时候:
      #client = OauthChina::Sina.load(:access_token => "xx", :access_token_secret => "xxx")
      #client.add_status("同步到新浪微薄..")
      # xml
      # text =  client.access_token.get "/account/verify_credentials.xml"  
      # doc = Document.new(text.body)  
      # oauth_login("sina",doc.root.elements[1].text,doc.root.elements[3].text,doc.root.elements[2].text)
      account = client.access_token.get("/account/verify_credentials.json")
      data = JSON.parse(account.body)
      render :json => data.to_json
      #在这里把access token and access token secret存到db
      # data["profile_image_url"] # 头象
      # oauth_login("sina", data["id"], data["name"], data["screen_name"], results)
    else
      flash[:notice] = "授权失败!"
      redirect_to "/syncs/sina_new"
    end
  end

  def sina_send
    sina_uid = params[:sina_uid]
    message = params[:message]
    options = params[:options]
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    if sina_user.nil?
      redirect_to :action => "sina_new"
    else
      @send = false
      @result = {}
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      status = client.add_status(message)
      if status.code == "200"
        @send = true
        data = JSON.parse(status.read_body)
        id = data["id"]
        text = data["text"]
        @result["id"] = id
        @result["text"] = text
      end
      @result["send"] = @send
      render :json => { :result => @result }.to_json
    end
  end

  def sina_upload
    sina_uid = params[:sina_uid]
    message = params[:message]
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    if sina_user.nil?
      redirect_to :action => "sina_new"
    else
      @send = false
      @result = {}
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      options = {}
      options["status"] = message
      options["Content-Type"] = 'multipart/form-data'
      options["pic"] = params[:pic].read
      options.update(client.consumer_options)
      status = client.post('http://api.t.sina.com.cn/statuses/upload.json', options) 
      if status.code == "200"
        @send = true
        data = JSON.parse(status.read_body)
        id = data["id"]
        text = data["text"]
        @result["id"] = id
        @result["text"] = text
        @result["thumbnail_pic"] = data["thumbnail_pic"]
        @result["bmiddle_pic"] = data["bmiddle_pic"]
        @result["original_pic"] = data["original_pic"]
      end
      @result["send"] = @send
      render :json => { :result => @result }.to_json
    end
  end

  def sina_show
    sina_uid = params[:sina_uid]
    id = params[:id]
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    if sina_user.nil?
      redirect_to :action => "sina_new"
    else
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      status = client.get("http://api.t.sina.com.cn/#{sina_uid}/statuses/#{id}")
      data = JSON.parse(status.header.to_json)
      redirect_to data["header"]["location"].to_s
    end
  end

  def qq_new
    client = OauthChina::Qq.new
    authorize_url = client.authorize_url
    Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
    redirect_to authorize_url
  end

  def qq_callback
    client = OauthChina::Qq.load(Rails.cache.read(build_oauth_token_key("qq", params[:oauth_token])))
    client.authorize(:oauth_verifier => params[:oauth_verifier])

    results = client.dump

    if results[:access_token] && results[:access_token_secret]
      #在这里把access token and access token secret存到db
      #下次使用的时候:
      #client = OauthChina::Sina.load(:access_token => "xx", :access_token_secret => "xxx")
      #client.add_status("同步到新浪微薄..")
      # xml
      # text =  client.access_token.get "http://open.t.qq.com/api/user/info?format=xml"  
      # doc = Document.new(text.body)
      # uid 用户ID目前为空
      # oauth_login("qq",'', doc.root.elements[1].elements[14].text,doc.root.elements[1].elements[15].text)
      account = client.access_token.get("http://open.t.qq.com/api/user/info?format=json")
      data = JSON.parse(account.body)
      flash[:notice] = "授权成功！"
      # data["data"]["head"] # 头象url
      oauth_login("qq", data["data"]["uid"], data["data"]["name"], data["data"]["nick"])
    else
      flash[:notice] = "授权失败!"
      redirect_to "/syncs/qq_new"
    end
  end

  def douban_new
    client = OauthChina::Douban.new
    authorize_url = client.authorize_url
    Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
    redirect_to authorize_url
  end

  def douban_callback
    client = OauthChina::Douban.load(Rails.cache.read(build_oauth_token_key("douban", params[:oauth_token])))
    client.authorize(:oauth_verifier => params[:oauth_verifier])
    results = client.dump
    if results[:access_token] && results[:access_token_secret]
      #在这里把access token and access token secret存到db
      #下次使用的时候:
      #client = OauthChina::Douban.load(:access_token => "xx", :access_token_secret => "xxx")
      #client.add_status("同步到新浪微薄..")
      # xml
      text =  client.access_token.get "http://api.douban.com/people/%40me"  
      doc = Document.new(text.body)  
      s = doc.root.elements[1].text
      s = s[s.rindex("/")+1,s.length-s.rindex("/")]
      flash[:notice] = "授权成功！"
      oauth_login("douban",s,doc.root.elements[2].text,doc.root.elements[2].text)
    else
      flash[:notice] = "授权失败!"
      redirect_to "/syncs/douban_new"
    end
  end

  def sohu_new
    client = OauthChina::Sohu.new
    authorize_url = client.authorize_url
    Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
    redirect_to authorize_url
  end

  def sohu_callback
    client = OauthChina::Sohu.load(Rails.cache.read(build_oauth_token_key("sohu", params[:oauth_token])))
    client.authorize(:oauth_verifier => params[:oauth_verifier])

    results = client.dump

    if results[:access_token] && results[:access_token_secret]
      #在这里把access token and access token secret存到db
      #下次使用的时候:
      #client = OauthChina::Sina.load(:access_token => "xx", :access_token_secret => "xxx")
      #client.add_status("同步到新浪微薄..")
      # xml
      # text =  client.access_token.get "http://api.t.sohu.com/account/vefiry_credentials.xml"  
      # doc = Document.new(text.body)  
      # oauth_login("sohu",doc.root.elements[1].text,doc.root.elements[3].text ? doc.root.elements[3].text : "",doc.root.elements[2].text)
      account = client.access_token.get("http://api.t.sohu.com/account/verify_credentials.json")
      data = JSON.parse(account.body)
      flash[:notice] = "授权成功！"
      oauth_login("sohu", data["id"], data["name"], data["screen_name"])
    else
      flash[:notice] = "授权失败!"
      redirect_to "/syncs/sohu_new"
    end
  end

  def netease_new
    client = OauthChina::Netease.new
    authorize_url = client.authorize_url
    Rails.cache.write(build_oauth_token_key(client.name, client.oauth_token), client.dump)
    redirect_to authorize_url
  end

  def netease_callback
    client = OauthChina::Netease.load(Rails.cache.read(build_oauth_token_key("netease", params[:oauth_token])))
    client.authorize(:oauth_verifier => params[:oauth_verifier])

    results = client.dump
    if results[:access_token] && results[:access_token_secret]
      #在这里把access token and access token secret存到db
      #下次使用的时候:
      #client = OauthChina::Sina.load(:access_token => "xx", :access_token_secret => "xxx")
      #client.add_status("同步到新浪微薄..")
      # xml
      # text =  client.access_token.get "http://api.t.163.com/account/verify_credentials.xml"  
      # doc = Document.new(text.body)  
      # oauth_login("netease",doc.root.elements[1].text,doc.root.elements[3].text ? doc.root.elements[3].text : "",doc.root.elements[2].text)
      account = client.access_token.get("http://api.t.163.com/account/verify_credentials.xml")
      data = JSON.parse(account.body)
      flash[:notice] = "授权成功！"
      oauth_login("netease", data["id"], data["name"], data["screen_name"])
    else
      flash[:notice] = "授权失败!"
      redirect_to "/syncs/neteasy_new"
    end
  end


  private
  def build_oauth_token_key(name, oauth_token)
    [name, oauth_token].join("_")
  end

  def oauth_login(oauth_t,oauth_id,oauth_name,oauth_nickname, results)
    # 腾讯微博uid 用户ID目前为空, 每个网站的oauth_name不为空,与不可重复
    user = User.find_by_oauth_t_and_oauth_name(oauth_t,oauth_name)
    if user.nil?
      user = User.new
      user.oauth_t = oauth_t
      user.oauth_id = oauth_id
      user.oauth_name = oauth_name
      user.name = oauth_name+"＠#{oauth_t}"
      user.nickname = oauth_nickname+"＠#{oauth_t}"
      user.password = oauth_t + oauth_name
      user.save!
    end
    user_login_log = UserLoginLog.new
    user_login_log.login_time = Time.zone.now
    user_login_log.ip = request.remote_ip
    user_login_log.name = user.name
    user_login_log.user_id = user.id
    user_login_log.login_suc = true
    user_login_log.save

    if oauth_t == "sina"
      sina_user = SinaUser.find_by_sina_uid(user.oauth_id)
      if sina_user.nil?
        sina_user = SinaUser.new
        sina_user.sina_uid = user.oauth_id
        sina_user.access_token = results[:access_token]
        sina_user.token_secret = results[:access_token_secret]
        sina_user.save
      end
    end
    if user.shop_id.nil?
      session[:shop_id] = user.my_shop.id unless user.my_shop.nil?
      user_login_redirect user
    else
      session[:user_id] = user.id
      session[:shop_id] = user.shop_id
      shop_login_redirect Shop.find_by_id(session[:shop_id])
    end
  end

end
