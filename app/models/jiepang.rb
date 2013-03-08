# encoding: utf-8
class Jiepang
  Logger = Logger.new('log/jiepang.log', 0, 100 * 1024 * 1024)

  include Mongoid::Document
  store_in session: "dooo"

  def self.insert(lo)
    10.times do |x|
      next if x%2==0
      10.times do |y|
        next if y%2==0  
        #puts "#{[lo[0]+x*0.001, lo[1]+y*0.001]}"
        Jiepang.insert0([lo[0]+x*0.001, lo[1]+y*0.001])
      end
    end
  end
    
  def self.insert0(lo)
    datas = Jiepang.get_loc(lo)
    sleep(2)
    return nil if datas.nil?
    datas["items"].each do |x|
      x["_id"] = x["guid"]
      x.delete("guid")
      begin
        Jiepang.collection.insert(x)
      rescue Exception => e
        Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} insert #{x}错误."
        Logger.error e
      end
    end
    return datas
  end
  
  def self.get_loc(lo,err_num=0)
    url = "http://api.jiepang.com/v1/discover/featured_locations?lat=#{lo[0]}&lon=#{lo[1]}&count=100&source=100760"
    begin
      response = RestClient.get(url)
      Logger.info "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} get #{url}"
    rescue RestClient::BadRequest
      Logger.info "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} BadRequest #{url}"
      return nil
    rescue
      err_num += 1
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} get #{url}错误#{err_num}次. #{$!}"
      Emailer.send_mail('Jiepang出错',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} get #{url}错误. #{$!}").deliver if err_num == 4
      return nil if err_num == 4
      sleep err_num * 20
      return self.get_loc(lo, err_num)
    end
    JSON.parse response
  end

end
