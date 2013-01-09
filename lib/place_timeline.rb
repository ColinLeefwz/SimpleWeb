# encoding: utf-8
module PlaceTimeline
  Logger = Logger.new('log/weibo/palce_timeline.log', 0, 100 * 1024 * 1024)
  def self.start
    self.update_poi('2.00t9e5PCMcnDPC86e7068cc9yxaMRC')
  end

  def self.update_poi(token)
    place_timelne = public_timeline(token)
    return if place_timelne.blank?
    return if (statuses = place_timelne['statuses']).blank?
    sucoll = SinaUser.collection

    statuses.each do |statu|
      pois = statu['annotations']
      next if pois.blank?
      pois.each do |poi|
        poiid= poi['place']['poiid']
        next if poiid == '(null)'
        sina_poi = SinaPoi.find_by_id(poiid)
        if sina_poi
          datas = sina_poi.respond_to?(:datas) ? sina_poi.datas : []
          iso_num = sina_poi.respond_to?(:iso_num) ? sina_poi.iso_num : 0
          user = statu['user']
          uid = user.delete('id')
          next if datas.detect{|data| data[0] == uid && data[1]== statu['text'] && data[2] == statu['source'] }
          sucoll.insert(user.merge({:_id => uid})) unless SinaUser.has_user?(uid)
          datas << [uid, statu['text'], statu['source'], statu['created_at'].to_datetime.strftime("%Y-%m-%d %H:%M:%S")]
          iso_num +=1 if statu['source'].to_s.match(/iphone|ipad/i)
          sina_poi.update_attributes({:datas => datas, :iso_num => iso_num, :checkin_user_num => (sina_poi.checkin_user_num +1)})
        else
          SinaPoi.insert_poi(token, poiid)
          SinaPoi.pois_users_insert(token, poiid)
        end
      end

      
    end
  end

  def self.public_timeline(token, err_num=0)
    url =  "https://api.weibo.com/2/place/public_timeline.json?access_token=#{token}&count=50"
    begin
      response = RestClient.get(url)
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} PlaceTimeline#public_timeline get #{url}"
    rescue
      err_num += 1
      Emailer.send_mail('获取最新公共的位置动态出错',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} PlaceTimeline#public_timeline get #{url}错误. #{$!}").deliver if err_num == 4
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} PlaceTimeline#public_timeline get #{url}错误#{err_num}次. #{$!}"
      return nil if err_num == 4
      sleep err_num * 20
      return public_timeline(token, err_num)
    end
    JSON.parse response
  end
  
end

