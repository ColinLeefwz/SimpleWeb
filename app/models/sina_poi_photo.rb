# encoding: utf-8
class SinaPoiPhoto

  $Logger = Logger.new('log/weibo/sina_photos.log', 0, 100 * 1024 * 1024)
  include Mongoid::Document
  store_in session: "dooo"

  def self.start
    num = (SinaPoi.where({:photo_fetched => {'$exists' => false}}).count/3000)+1
    num.times do |t|
      SinaPoi.where({:iso_num => {'$gt' => 0}, :photo_fetched => {'$exists' => false} }).sort({iso_num:-1}).skip(t*20).limit(20).each do |poi|
        self.poi_photo_insert('2.00t9e5PCMcnDPC86e7068cc9yxaMRC', poi._id)
        poi.update_attribute(:photo_fetched, 1)
      end
    end
  end

  def self.poi_photo_insert(token, poiid)
    return if find_by_id(poiid)
    datas = []
    coll = self.collection
    sucoll = SinaUser.collection
    photos = poi_photo_page(token, poiid)
    return if photos.blank? || photos['statuses'].blank?
    photos['statuses'].each do |photo|
      begin
        next if photo['deleted']
        hash = photo.slice('text', 'original_pic', "created_at")
        uid = photo['user'].delete('id')
        sucoll.insert(photo['user'].merge(_id: uid )) unless SinaUser.has_user?(uid)
        datas << hash.merge(user_id: uid)
      rescue
        next
      end
    end
    coll.insert(_id: poiid, datas: datas)
  end
  
  def self.poi_photo_page(token, poiid, err_num = 0)
    sleep(2)
    url = "https://api.weibo.com/2/place/pois/photos.json?poiid=#{poiid}&access_token=#{token}"
    begin
      response = RestClient.get(url)
      $Logger.info "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoiPhoto.poi_photo_page get #{url}"
    rescue
      err_num += 1
      Emailer.send_mail('poi_photo_page错误',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoiPhoto.poi_photo_page get #{url}错误. #{$!}").deliver if err_num == 4
      $Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoiPhoto.poi_photo_page get #{url}错误#{err_num}次. #{$!}"
      return nil if err_num == 4
      sleep err_num * 20
      return poi_photo_page(token, poiid, err_num )
    end
    response = JSON.parse response
  end

end
