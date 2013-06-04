# encoding: utf-8
class SinaAdvt
  include Mongoid::Document
  extend RequestApi
  store_in session: "dooo"
  
  Log =  Logger.new('log/weibo/sina_advt.log', 0, 100 * 1024 * 1024)
  request_sina :create_com, Log  #创建评论接口调用
  request_sina :place_timeline, Log #获取共用位置信息的接口调用
  request_sina :geo_to_address, Log #坐标转实际位置的接口调用
  request_sina :repost, Log # 转发并@

  class << self; attr_accessor :dtime;  end
  

  field :wbid
  field :wb_uid #发给聊天室

  def self.com
    c = place_repost
    place_repost if c.nil?
  end


  #获取动态签到微博，并转发并评论
  def self.place_repost
    @dtime = Rails.cache.fetch("SINAADVT").to_i
    places = place_timelines
    tokens = WeiboUser::USER2.map{|m|  $redis.get("wbtoken#{m}")}.compact
    return unless places.is_a?(Array)
    places.each do |place|
      next unless is_iphone?(place)
      token = fetch_token(tokens)
      status =  comment_text( get_poi(place))
      Rails.cache.set("SINAADVT",  self.dtime += 1)
      next unless  do_repost( place['id'], status, token)
      self.create(:wbid => place['id'], :wb_uid => place['user']['id']  )
    end
  end

  def is_iphone?(place)
    place['source'] =~ /iPhone|ipad/i
  rescue
    nil
  end

  #转发并评论指定的微博
  def self.do_repost(wbid, status, token)
    params = { "id" => wbid,  "status" => status, "access_token" => token,"is_comment" => 1}
    #    params = { "id" => '3560414669383960',  "status" => status, "access_token" => token,"is_comment" => 1}
    url = "https://api.weibo.com/2/statuses/repost.json"
    repost(:url => url, :method => :post, :params => params, :email_title => "转发并评论签到微博出错" )
  end

  #  #  private

  #获取最新公共的位置的签到动态
  def self.place_timelines
    url = "https://api.weibo.com/2/place/public_timeline.json"
    response =  place_timeline(:url => url, :method => :get, :params => {:access_token=> $sina_token, :count => WeiboUser::USER2.length}, :email_title => "获取最新公共的位置动态接口出错")
    return unless response.is_a?(Hash)
    response['statuses']
  end

  #数组中循环选择评论语句
  def self.comment_text(poi)
    advts = WeiboUser::ADVTS
    len = advts.length
    index = dtime%len
    content = advts[index]
    content.gsub(/#XXX/, poi.blank? ? "这里" : poi)+ "   下载地址： http://www.dface.cn/a?v=20#{index.to_s.rjust(3,'0')}"
  end

  #获取签到poi的名称
  def self.get_poi(place)
    poi = place['annotations']
    unless poi.nil?
      pl =  poi.first['place']
      return pl['title'] if pl.is_a?(Hash)
    end
    
    return #测试用， 正式用时取消这行
    if poi.nil?
      lo = place['geo']['coordinates']
      url = "https://api.weibo.com/2/location/geo/geo_to_address.json"
      lo = lo.reverse.join(',')
      params = {:access_token=> $sina_token, :coordinate => lo}
      res = geo_to_address(:url => url, :method => :get, :params => params)
      return if res.nil?
      geo = res['geos'].first
      address = geo['address']
      name = geo['name']
      address.to_s+name.to_s
    else
      poi.first['place']['title']
    end
  end

  def self.fetch_token(tokens)
    len = tokens.length
    tokens[dtime%len]
  end
  

end