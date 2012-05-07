require 'json'

class SinaWeibo
  def self.shop_update(sina_uid, class_name, id, user_id = nil, options = {})
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    user = User.find_by_oauth_id(sina_uid)
    @send = false
    unless sina_user.nil?
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      status = client.add_status(user_id.to_i > 0 ? user_message(user_id, class_name, id) : shop_message(user.shop_id, class_name, id))
      @send = true if status.code == "200"
    end
    return @send
  end

  def self.user_update(sina_uid, class_name, id, options = {})
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    user = User.find_by_oauth_id(sina_uid)
    @send = false
    unless sina_user.nil?
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      status = client.add_status(user_message(user.id, class_name, id))
      @send = true if status.code == "200"
    end
    return @send
  end

  def self.user(sina_uid)
    user = nil
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    unless sina_user.nil?
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      account = client.get("http://api.t.sina.com.cn/users/show/#{sina_uid}.json")
      if account.code == "200"
        body = JSON.parse(account.body)
        status = body["status"].blank? ? nil : SinaWeiboStatus.new(body["status"]["id"], body["status"]["created_at"], body["status"]["text"], body["status"]["source"], body["status"]["favorited"], body["status"]["truncated"], body["status"]["geo"], body["status"]["in_reply_to_status_id"], body["status"]["in_reply_to_user_id"], body["status"]["in_reply_to_screen_name"])
        user = SinaWeiboUser.new(body["id"], body["screen_name"], body["province"], body["city"], body["location"], body["description"], body["url"], body["profile_image_url"], body["domain"], body["gender"], body["followers_count"], body["friends_count"], body["statuses_count"], body["favourites_count"], body["created_at"], body["following"], body["verified"], body["allow_all_act_msg"], body["geo_enabled"], status)
      end
    end
    return user
  end

  def self.statuses_followers(sina_uid)
    users = []
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    unless sina_user.nil?
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      account = client.get("http://api.t.sina.com.cn/statuses/followers/#{sina_uid}.json?cursor=-1&count=200")
      if account.code == "200"
        body = JSON.parse(account.body)
        body["users"].each do |user|
          status = user["status"].blank? ? nil : SinaWeiboStatus.new(user["status"]["id"], user["status"]["created_at"], user["status"]["text"], user["status"]["source"], user["status"]["favorited"], user["status"]["truncated"], user["status"]["geo"], user["status"]["in_reply_to_status_id"], user["status"]["in_reply_to_user_id"], user["status"]["in_reply_to_screen_name"])
          users << SinaWeiboUser.new(user["id"], user["screen_name"], user["province"], user["city"], user["location"], user["description"], user["url"], user["profile_image_url"], user["domain"], user["gender"], user["followers_count"], user["friends_count"], user["statuses_count"], user["favourites_count"], user["created_at"], user["following"], user["verified"], user["allow_all_act_msg"], user["geo_enabled"], status)
        end
        next_cursor = body["next_cursor"].to_i
        while next_cursor.to_i > 0
          account_i = client.get("http://api.t.sina.com.cn/statuses/followers/#{sina_uid}.json?cursor=#{next_cursor}&count=200")
          if account_i.code == "200"
            body_i = JSON.parse(account_i.body)
            body_i["users"].each do |user|
              status_i = user["status"].blank? ? nil : SinaWeiboStatus.new(user["status"]["id"], user["status"]["created_at"], user["status"]["text"], user["status"]["source"], user["status"]["favorited"], user["status"]["truncated"], user["status"]["geo"], user["status"]["in_reply_to_status_id"], user["status"]["in_reply_to_user_id"], user["status"]["in_reply_to_screen_name"])
              users << SinaWeiboUser.new(user["id"], user["screen_name"], user["province"], user["city"], user["location"], user["description"], user["url"], user["profile_image_url"], user["domain"], user["gender"], user["followers_count"], user["friends_count"], user["statuses_count"], user["favourites_count"], user["created_at"], user["following"], user["verified"], user["allow_all_act_msg"], user["geo_enabled"], status_i)
            end
            next_cursor = body_i["next_cursor"].to_i
          else
            next_cursor = 0
          end
        end
      end
    end
    return users
  end

  def self.followers_count(sina_uid)
    count = 0
    sina_user = SinaUser.find_by_sina_uid(sina_uid)
    unless sina_user.nil?
      client = OauthChina::Sina.load(:access_token => sina_user.access_token, :access_token_secret => sina_user.token_secret)
      account = client.get("http://api.t.sina.com.cn/users/show/#{sina_uid}.json")
      if account.code == "200"
        c_user = JSON.parse(account.body)
        count = c_user["followers_count"]
      end
    end
    return count.to_i
  end

  def self.user_message(user_id, class_name, id)
    message = ''
    user = User.find_by_id(user_id)
    if class_name == "tuangou"
      tuangou = Tuangou.find_by_id(id)
      shop = tuangou.shop_id.blank? ? tuangou.discount.shop : Shop.find_by_id(tuangou.shop_id)
      message = "#{user.name}购买了#{shop.name}的团购券#{tuangou.screen_name}团购地址:http://www.1dooo.com/tuangou_list/show/#{id}"
    elsif class_name == "discount"
      discount = Discount.find_by_id(id)
      message = "#{user.name}购买了#{discount.shop.name}的优惠券#{discount.name}优惠地址:http://www.1dooo.com/shop_space/discount/#{id}?shop_id=#{shop.id}"
    elsif class_name == "cash_tuangou"
      tuangou = Tuangou.find_by_id(id)
      shop = tuangou.shop_id.blank? ? tuangou.discount.shop : Shop.find_by_id(tuangou.shop_id)
      message = "#{user.name}消费了#{shop.name}的团购券#{tuangou.screen_name}团购地址:http://www.1dooo.com/tuangou_list/show/#{id}"
    elsif class_name == "cash_discount"
      discount = Discount.find_by_id(id)
      message = "#{user.name}消费了#{discount.shop.name}的优惠券#{discount.name}优惠地址:http://www.1dooo.com/shop_space/discount/#{id}?shop_id=#{discount.shop_id}"
    elsif class_name == "comment"
      comment = ActiveRecord::Base::Comment.find_by_id(id)
      if comment.discount_id.to_i > 0
        discount = Discount.find_by_id(comment.discount_id)
        shop = discount.shop
        message = "#{user.name}对#{shop.name}的优惠券#{discount.name}优惠地址:http://www.1dooo.com/shop_space/discount/#{id}?shop_id=#{shop.id}发表了评论:#{comment.body.gsub(/<(\S*?)[^>]*>.*?<\/\1>|<.*? \/>/, '')}"
      elsif comment.article_id.to_i > 0
        article = Article.find_by_id(comment.article_id)
        shop = article.shop
        message = "#{user.name}对#{shop.name}的文章#{article.name}http://www.1dooo.com/shop_space/article/#{id}?shop_id=#{shop.id}发表了评论:#{comment.body.gsub(/<(\S*?)[^>]*>.*?<\/\1>|<.*? \/>/, '')}"
      elsif comment.shop_photo_id.to_i > 0
        shop_photo = ShopPhoto.find_by_id(comment.shop_photo_id)
        shop = shop_photo.shop
        message = "#{user.name}对#{shop.name}的图片#{shop_photo.name}http://www.1dooo.com/shop_space/photo/#{id}?shop_id=#{shop.id}发表了评论:#{comment.body.gsub(/<(\S*?)[^>]*>.*?<\/\1>|<.*? \/>/, '')}"
      else
        shop = Shop.find_by_id(comment.shop_id)
        message = "#{user.name}对#{shop.name}发表了评论:#{comment.body.gsub(/<(\S*?)[^>]*>.*?<\/\1>|<.*? \/>/, '')}"
      end
    elsif class_name == "user_shop_like"
      u_s_like = UserShopLike.find_by_id(id)
      shop = Shop.find_by_id(u_s_like.shop_id)
      message = "#{user.name}关注了#{shop.name}[IShop主页:http://www.1dooo.com/shop_space/space/#{shop.id}]"
    end
    return message
  end

  def self.shop_message(shop_id, class_name, id)
    message = ''
    shop = Shop.find_by_id(shop_id)
    if class_name == "tuangou"
      tuangou = Tuangou.find_by_id(id)
      message = "#{shop.name}发布了团购券#{tuangou.screen_name}团购地址:http://www.1dooo.com/tuangou_list/show/#{id}"
    elsif class_name == "discount"
      discount = Discount.find_by_id(id)
      message = "#{shop.name}发布了优惠券#{discount.name}优惠地址:http://www.1dooo.com/shop_space/discount/#{id}?shop_id=#{shop.id}"
    elsif class_name == "article"
      article = Article.find_by_id(id)
      message = "#{shop.name}发布了#{article.menu.name}#{article.title}http://www.1dooo.com/shop_space/article/#{id}?shop_id=#{shop.id}"
    elsif class_name == "photo"
      photo = ShopPhoto.find_by_id(id)
      if photo && photo.menu && photo.menu.shop_id == shop.id
        message = "#{shop.name}上传了#{photo.menu.name}#{photo.name}http://www.1dooo.com/shop_space/photo/#{id}?shop_id=#{shop.id}"
      else
        message = "#{shop.name}上传了#{photo.name}http://www.1dooo.com/shop_space/space/#{shop.id}"
      end
    end
    return message
  end

end
