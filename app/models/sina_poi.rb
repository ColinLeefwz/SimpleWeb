# encoding: utf-8
class SinaPoi
  include Mongoid::Document
  store_in session: "dooo"

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
          if ba = check_baidu(d['title'], [d['lat'].to_f, d['lon'].to_f])
            d.merge!({"baidu_id" => ba._id})
          end
          coll.insert({:_id => id }.merge(d))
          pois_users_insert(token, id)
        end
      end
    end
  end


  def self.pois_users_insert(token, poiid)
    sucoll, datas =   SinaUser.collection, []
    response = poi_user_page(token, poiid)
    return if response.blank?
    total_number = response["total_number"]
    1.upto((total_number-1)/50+1) do |page|
      sinausers = poi_user_page(token, poiid, page)
      next unless sinausers.is_a?(Hash)
      sinausers['users'].to_a.each do |r|
        datas << [r["id"], r["status"]['text'], r["status"]['source'], r["checkin_at"]]
        id = r.delete("id")
        sucoll.insert({:_id =>  id }.merge(user_get_attributes(r))) unless SinaUser.find_by_id(id)
      end
    end
    SinaPoi.find(poiid).update_attribute(:datas, datas)
  end

  def self.check_baidu(name, lo)
#    return nil
    baidu = Baidu.where({:name => name, :lo => {"$within" => {"$center" => [lo, 0.01]}}}).to_a.first
    return baidu if baidu
    
    if name.last==')'
      name2 = name.gsub(/[()]/, '')
      baidu = Baidu.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.002]}}}).to_a.first
      return baidu if baidu
    end
    
    nil
  end

  private
  def self.pois(token,lo, page=1, err_num = 0)
    sleep(1)
    url = "https://api.weibo.com/2/place/nearby/pois.json?count=50&page=#{page}&lat=#{lo[0]}&long=#{lo[1]}&access_token=#{token}"
    begin
      response = RestClient.get(url)
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}."
    rescue
      err_num += 1
      return nil if err_num == 4
      sleep 1 * 20
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}错误，. #{$!}"
      return pois(token,lo, page,err_num)
    end
    JSON.parse response
  end

  def self.poi_user_page(token, poiid, page=1, err_num = 0)
    sleep(1)
    url =  "https://api.weibo.com/2/place/pois/users.json?poiid=#{poiid}&access_token=#{token}&count=50&page=#{page}"
    begin
      response = RestClient.get(url)
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}"
    rescue
      err_num += 1
      return nil if err_num == 4
      sleep 1 * 20
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}错误，. #{$!}"
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

end
