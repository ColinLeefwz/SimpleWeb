# encoding: utf-8
class QqInfo
  include Mongoid::Document
  store_in session: "dooo"

  Logger = Logger.new('log/weibo/qq_info.log', 0, 100 * 1024 * 1024)

  def self.insert_info(user)
    token = $redis.get("qqtoken#{user.id}")
    openid = user.qq
    return if (info = get_info(token, openid)).nil? || info['ret'] != 0
    self.collection.insert({_id: openid, data: info['data']})
  end


  def self.get_info(token, openid, err_num = 0)
    url = "https://graph.qq.com/user/get_info?oauth_consumer_key=#{$qq_api_key}&access_token=#{token}&openid=#{openid}&format=json"
    begin
      response = RestClient.get(url)
    rescue RestClient::BadRequest
      return nil
    rescue
      err_num += 1
      Emailer.send_mail('qq抓取出错',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} QqInfo#get_info #{url}错误. #{$!}").deliver if err_num == 4
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} QqInfo#get_info get #{url}错误#{err_num}次，. #{$!}"
      return nil if err_num == 4
    end
    JSON.parse(response)
  end

end
