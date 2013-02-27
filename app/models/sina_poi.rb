# encoding: utf-8
class SinaPoi
  #mtype 字段 5是手工匹配的

  Logger = Logger.new('log/weibo/sina_poi.log', 0, 100 * 1024 * 1024)

  include Mongoid::Document
  store_in session: "dooo"
  
  index({checkin_user_num: 1}, { sparse: true })
  index({iso_num: 1}, { sparse: true })
  index({photo_fetched: 1}, { sparse: true })
  create_indexes

  def self.insert_poi(token, poiid)
    poi = poi_page(token, poiid)
    poiid = poi.delete('poiid')
    self.collection.insert(poi.merge({:_id => poiid})) unless self.find_by_id(poiid)
  end


  def self.pois_insert(token,lo)
    coll = self.collection
    response = pois(token, lo)
    return if response.blank?
    total_number = pois(token, lo)["total_number"]
    1.upto((total_number-1)/50+1) do |page|
      tmp_pois = pois(token,lo, page)
      next unless tmp_pois.is_a?(Hash)
      tmp_pois["pois"].to_a.each do |d|
        id = d.delete("poiid")
        if coll.find({:_id => id}).to_a.blank?
          begin
            lo = Mongoid.session(:dooo).command(eval:"gcj02_to_real([#{d['lat'].to_f},#{d['lon'].to_f}])")["retval"]
            d.merge!({lo: lo})
            ba = check(d['title'], lo)
            unless ba.blank?
              d.merge!(ba)
            end
            dt = get_t(d['category_name'])
            d.merge!(dt) if dt
          rescue Exception => e
            # end pattern with unmatched parenthesis: /^老庙黄金(东宝店）/ (RegexpError)
            Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} #{e}"
          end
          coll.insert({:_id => id }.merge(d))
          pois_users_insert(token, id)
        end
      end
    end
  end


  def self.pois_users_insert(token, poiid)
    sucoll, datas, checkin_user_num, iso_num =   SinaUser.collection, [], 0, 0
    response = poi_user_page(token, poiid)
    return if response.blank?
    total_number = response["total_number"]
    1.upto((total_number-1)/50+1) do |page|
      begin
        sinausers = poi_user_page(token, poiid, page)
        next unless sinausers.is_a?(Hash)
        sinausers['users'].to_a.each do |r|
          status = r["status"]
          datas << [r["id"], status && status['text'], status && status['source'], r["checkin_at"]]
          checkin_user_num +=1
          iso_num += 1 if iso?(status && status['source'])
          id = r.delete("id")
          sucoll.insert({:_id =>  id }.merge(user_get_attributes(r))) unless SinaUser.find_by_id(id)
        end
      rescue
        next
      end
    end
    SinaPoi.find(poiid).update_attributes(:datas => datas, :checkin_user_num => checkin_user_num, :iso_num => iso_num  )
  end

  def self.check(name, lo)
    self.check_shop(name, lo) || self.check_baidu(name, lo)
  end

  def self.check_baidu(name, lo)
    baidu = Baidu.where({:name => name, :lo => {"$within" => {"$center" => [lo, 0.01]}}}).to_a.first
    return {baidu_id: baidu._id, mtype: 1} if baidu
    if name.match(/[()（） \[\].]/)
      name1 = name.split(/[()（） \[\].]/)
      name2 = name1.first
      baidu = Baidu.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {baidu_id: baidu._id, mtype: 2} if baidu
      name2 = name1.join('')
      baidu = Baidu.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {baidu_id: baidu._id, mtype: 3} if baidu
      baidu = Baidu.where({:name => /^#{name1.first}/,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {baidu_id: baidu._id, mtype: 4} if baidu
    else
      baidu = Baidu.where({:name => /^#{name}/,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {baidu_id: baidu._id, mtype: 4} if baidu
    end
    nil
  end

  def self.check_shop(name, lo)
    shop = Shop.where({:name => name, :lo => {"$within" => {"$center" => [lo, 0.01]}}}).to_a.first
    return {shop_id: shop._id.to_i, mtype: 1  } if shop

    if name.match(/[()（） \[\].]/)
      name1 = name.split(/[()（） \[\].]/)
      name2 = name1.first
      shop = Shop.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {shop_id: shop._id.to_i, mtype: 2  } if shop
      name2 = name1.join('')
      shop = Shop.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {shop_id: shop._id.to_i, mtype: 3  } if shop
      shop = Shop.where({:name => /^#{name1.first}/,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {shop_id: shop._id.to_i, mtype: 4    } if shop
    else
      shop = Shop.where({:name => /^#{name}/,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return {shop_id: shop._id.to_i, mtype: 4    } if shop
    end
    nil
  end

  def self.poi_page(token, poiid, err_num = 0)
    url = "https://api.weibo.com/2/place/pois/show.json?poiid=#{poiid}&access_token=#{token}"
    begin
      response = RestClient.get(url)
      Logger.info "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi.poi_page get #{url}"
    rescue RestClient::BadRequest
      return nil
    rescue
      sleep 3
      return nil
      err_num += 1
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi.poi_page get #{url}错误#{err_num}次. #{$!}"
      Emailer.send_mail('获取poi出错',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi.poi_page get #{url}错误. #{$!}").deliver if err_num == 4
      return nil if err_num == 4
      sleep err_num * 20
      return poi_page(token, poiid, err_num)
    end
    JSON.parse response
  end


  def show_dt
    SinaCategorys::SUPCATEGORY[self.dt] if self.respond_to?(:dt)
  end

  private
  def self.pois(token,lo, page=1, err_num = 0)
    sleep(2)
    url = "https://api.weibo.com/2/place/nearby/pois.json?count=50&page=#{page}&lat=#{lo[0]}&long=#{lo[1]}&access_token=#{token}"
    begin
      response = RestClient.get(url)
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}."
    rescue
      err_num += 1
      Emailer.send_mail('pois错误',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}错误. #{$!}").deliver if err_num == 4
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}错误#{err_num}次，. #{$!}"
      return nil if err_num == 4
      sleep err_num * 20
      return pois(token,lo, page,err_num)
    end
    JSON.parse response
  end

  def self.poi_user_page(token, poiid, page=1, err_num = 0)
    sleep(2)
    url =  "https://api.weibo.com/2/place/pois/users.json?poiid=#{poiid}&access_token=#{token}&count=50&page=#{page}"
    begin
      response = RestClient.get(url)
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}"
    rescue
      err_num += 1
      Emailer.send_mail('poi_user_page错误',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}错误. #{$!}").deliver if err_num == 4
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}错误#{err_num}次. #{$!}"
      return nil if err_num == 4
      sleep err_num * 20
      return poi_user_page(token, poiid, page, err_num)
    end
    response = JSON.parse response
  end

  def self.user_get_attributes(uhash)
    source = uhash["status"]['source']
    user = uhash.slice("screen_name","description","profile_image_url","gender","followers_count","friends_count","statuses_count",
      "favourites_count","created_at","allow_all_act_msg","geo_enabled","verified","verified_type","remark",
      "allow_all_comment","avatar_large","verified_reason")
    user.merge!({:is_I => true}) if source.match(/iphone|ipad/i)
    user
  end

  def self.get_t(category_name)
    index = SinaCategorys::SINACATEGORY.find_index{ |c| c.include?(category_name)  }
    {dt: index+1} if index
  end

  def self.iso?(source)
    source.to_s.match(/iphone|ipad/i)
  end

end
