# encoding: utf-8
class SinaFan
  include Mongoid::Document
  store_in session: "dooo"

  Logger = Logger.new('log/weibo/sina_fan.log', 0, 100 * 1024 * 1024)

  def self.start
    {'2045097601' => '陌陌科技', '1734536090' => '街旁', '1834134725' => '微领地', '2196734667' => '微博位置'}.each do |k,v|
      self.insert_fan($sina_token, k, :name => v)
    end
  end

  def self.insert_fan(token, wb_uid, option={})
    wb_uid = wb_uid.to_i
    cursor = 0
    return if self.find_by_id(wb_uid)
    ids = []
    coll = self.collection
    sucoll = SinaUser.collection
    fans = fans_page(token, wb_uid, cursor)
    total = fans['total_number']
    return if total.blank?
    ((total-1)/5000+1).times do |t|
      fans = fans_page(token, wb_uid, t*5000)
      fans['ids'].each do |id|
        unless SinaUser.has_user?(id)
          user = SinaUser.user_page(token, id)
          if user && user['id']
            uid = user.delete('id')
            sucoll.insert(user.merge(_id: uid ))
            ids << id
          end
        else
          ids << id
        end
      end
    end
    coll.insert({_id: wb_uid, ids: ids, name: option['name']})
  end

  def self.fans_page(token, wb_uid, cursor, err_num = 0)
    url = "https://api.weibo.com/2/friendships/followers/ids.json?count=5000&uid=#{wb_uid}&cursor=#{cursor}&access_token=#{token}"
    begin
      response = RestClient.get(url)
      Logger.info "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaFan.fans_page get #{url}"
    rescue
      err_num += 1
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaFan.fans_page get #{url}错误#{err_num}次. #{$!}"
      Emailer.send_mail('获取用户粉丝的用户UID列表出错',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaFan.fans_page get #{url}错误. #{$!}").deliver if err_num == 4
      return nil if err_num == 4
      sleep err_num * 20
      return fans_page(token, wb_uid, cursor, err_num )
    end
    JSON.parse response
  end


end
