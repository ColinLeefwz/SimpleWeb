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
          begin
            lo = Mongoid.session(:dooo).command(eval:"baidu_to_real([#{d['lat'].to_f},#{d['lon'].to_f}])")["retval"]
            d.merge!({lo: lo})
            if ba = check_baidu(d['title'], lo)
              d.merge!({"baidu_id" => ba.first, 'mtype' => ba.last})
            end
          rescue Exception => e 
            # end pattern with unmatched parenthesis: /^老庙黄金(东宝店）/ (RegexpError)
            $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} #{e}"
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
      begin
        sinausers = poi_user_page(token, poiid, page)
        next unless sinausers.is_a?(Hash)
        sinausers['users'].to_a.each do |r|
          status = r["status"]
          datas << [r["id"], status && status['text'], status && status['source'], r["checkin_at"]]
          id = r.delete("id")
          sucoll.insert({:_id =>  id }.merge(user_get_attributes(r))) unless SinaUser.find_by_id(id)
        end
      rescue
        next
      end
    end
    SinaPoi.find(poiid).update_attribute(:datas, datas)
  end


  def self.check_baidu(name, lo)

    baidu = Baidu.where({:name => name, :lo => {"$within" => {"$center" => [lo, 0.01]}}}).to_a.first
    return [baidu._id, 1] if baidu

    if name.match(/[()（） \[\].]/)
      name1 = name.split(/[()（） \[\].]/)
      name2 = name1.first
      baidu = Baidu.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return [baidu._id, 2] if baidu
      name2 = name1.join('')
      baidu = Baidu.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
      return [baidu._id, 3] if baidu
    end
    baidu = Baidu.where({:name => /^#{name}/,:lo => {"$within" => {"$center" => [lo,0.003]}}}).to_a.first
    return [baidu._id, 4] if baidu
    
    nil
  end

  private
  def self.pois(token,lo, page=1, err_num = 0)
    sleep(2)
    url = "https://api.weibo.com/2/place/nearby/pois.json?count=50&page=#{page}&lat=#{lo[0]}&long=#{lo[1]}&access_token=#{token}"
    begin
      response = RestClient.get(url)
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}."
    rescue
      err_num += 1
      Emailer.send_mail('pois错误',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}错误. #{$!}").deliver if err_num == 4
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}错误#{err_num}次，. #{$!}"
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
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}"
    rescue
      err_num += 1
      Emailer.send_mail('poi_user_page错误',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}错误. #{$!}").deliver if err_num == 4
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#poi_user_page get #{url}错误#{err_num}次. #{$!}"
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

end
