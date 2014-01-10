# coding: utf-8

class Gchat
  include Mongoid::Document
  field :sid, type: Integer #商家id
  field :uid,  type: Moped::BSON::ObjectId
  field :mid
  field :txt
  field :del, type: Boolean

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :gender, :birthday, :weibo_home,:show_gender, :to => :user
  end

  before_create :tryst2 

  # @@@我要回＋‘目的地’
  def tryst2
     return if self.txt[0,3] != '我要回' || sid.to_i !=  21838499 
     msg = self.txt
     user = self.user
     shop = self.shop
     reverse_render = [nil, 2, 1][user.gender.to_i]
     return false if reverse_render.nil?
     city = msg.sub('我要回','')
     muid = Termini.where({city: city, gender: reverse_render }).map{|m| m.uid}.sample(1).first
     termini = Termini.new({uid: user.id, city: city, gender: user.gender })
     pmj = termini.save
     ta = [nil,"他", "她"][reverse_render]
     if muid
      muser = User.find_by_id(muid)
      Xmpp.send_chat(muser.id, user.id, ": 今年春节，我也要回#{city}过年噢，快跟我打个招呼吧～", "GNHJSL#{shop.id}#{user.id}#{Time.now.to_i}")
      link = nil
      text = "#{ta}，叫#{muser.name}😊 今年春节#{ta}也要回#{city}噢！老乡见老乡，两眼泪汪汪😂 赶快返回对话页，和#{ta}打个招呼拉着小手一起回家过年吧！"
      Xmpp.send_link_gchat($gfuid,shop.id,user.id, text,link, "GNHJXC#{shop.id}#{user.id}#{Time.now.to_i}")
     else
      if pmj
        nanmj = ["52ae690720f31813e5000031", "51f73f9fc90d8bb76a000007", "528b3a3fc90d8b2871000001", "51418836c90d8bc37b000567", 
          "52ae669320f31813e5000027", "52ae587b20f318118300000c", "52ae575420f31813e5000007"]
        nvmj= ["51f9e3b9c90d8ba99d000002", "51dd2c7cc90d8b670a000032", "513ed1e7c90d8b590100016f", 
          "520c8391c90d8be3fb000003", "52ac6bd8c90d8bb3ea00001f", "52ac6e45c90d8b8f4e00002c", 
          "52ae563fc90d8ba59e000034", "528323dec90d8b9dd6000006", "525e6079c90d8b6de8000002"] 
        muid = [nil, nanmj, nvmj][reverse_render].sample(1).first
        muser = User.find_by_id(muid)
        Xmpp.send_chat(muser.id, user.id, ": 今年春节，我也要回#{city}过年噢，快跟我打个招呼吧～", "GNHJSL#{shop.id}#{user.id}#{Time.now.to_i}")
        link = nil
        text = "#{ta}，叫#{muser.name}😊 今年春节#{ta}也要回#{city}噢！老乡见老乡，两眼泪汪汪😂 赶快返回对话页，和#{ta}打个招呼拉着小手一起回家过年吧！"
        Xmpp.send_link_gchat($gfuid,shop.id,user.id, text,link, "GNHJXC#{shop.id}#{user.id}#{Time.now.to_i}")
      else
        text = '😢暂时没有和你同路的TA啦，过会再试试吧！也可戳我找寻同城的小伙伴噢～😉'
        link = 'dface://scheme/near/user' 
        Xmpp.send_link_gchat($gfuid,shop.id,user.id, text,link, "GNHJXC#{shop.id}#{user.id}#{Time.now.to_i}")
      end
     end
  end
  
  def user
    User.find_by_id(self.uid)
  end
  
  def shop
    Shop.find_by_id(self.sid)
  end
  
  def self.history_skip(sid,skip,pcount)
    arr = Gchat.where({sid:sid, del: nil }).sort({_id:-1}).skip(skip).limit(pcount).to_a
    arr
  end
  
  def self.history(sid,pcount,mid=nil)
    hash = {sid:sid, del: nil}
    if mid #mid参数待取消
      gchat = Gchat.where({mid:mid}).first
      hash.merge!({_id: {"$lt" => gchat.id} })
    end
    arr = Gchat.where(hash).sort({_id:-1}).limit(pcount).to_a
    arr
  end


  #db.gchats.ensureIndex({mid:1},{unique:true})

  def self.insert_to_mongo(chat,sid)
    begin
      text = chat[1].strip
      return nil if text.match(/(^0[1-9]?$)|(@@@)|(###)/)
      gchat = Gchat.new(uid: chat[0], sid: sid, mid: chat[3], txt: chat[1])
      gchat._id = (chat[2].to_s(16)+ '0'*10 +(0..9).to_a.sample(6).join('')).__mongoize_object_id__
      gchat.save
    rescue
      nil
    end
  end

  def self.remain_init_to_mongo(shop,skip, count)
    begin
      chats =shop.history(skip,count) 
      chats.each{|chat|  insert_to_mongo(chat, shop.id)}
      remain_init_to_mongo(shop,skip+count, count) if chats.count == count
    rescue
      return nil
    end
  end


  def self.init_to_mongo(initsid=0)
    #    sids = [21828775, 21835801, 21835409]
    File.open("/mnt/lianlian/log/gchat_init_to_mongo.log", 'w+') do |f|
      Checkin.distinct(:sid).sort.select{|m| m > initsid}.each do |id|
        begin
          shop = Shop.find_by_id(id)
          next if shop.nil?
          f.puts shop.id
          chats = shop.history(0,50)
          next if chats.blank?
          chats.each{|chat| insert_to_mongo(chat, shop.id) }
          remain_init_to_mongo(shop,50, 50) if chats.length ==50
        rescue
          next
        end
      end
    end
  end

  def self.init_to_mongo2
    File.open("/mnt/lianlian/log/gchat_init_to_mongo.log", 'w+') do |f|
      $redis.keys("UA*").each do |ua|
        begin
          cman = $redis.zcard(ua)
          sid = ua.gsub(/UA/,'' )
          if Gchat.history_skip(sid, 0, cman).size <  cman
            shop = Shop.find_by_id(sid)
            next if shop.nil?
            chats = shop.history(0,50)
            next if chats.blank?
            chats.each{|chat| insert_to_mongo(chat, shop.id) }
            remain_init_to_mongo(shop,50, 50) if chats.length ==50
          end
        rescue
          next
        end
      end
    end
  end


  def self.com_to_floor
    Gchat.where({txt: /^\[img:.{24}\]评论：/}).each do |gchat|
      begin
        txt = gchat.txt
        txt.match(/(^\[img:.{24}\]评论：)/)
        gr =  $1.sub(/\[/,'\[').sub(/\]/, '\]')
        floor = Gchat.where({txt: /#{gr}/}).sort({_id: 1}).to_a.index(gchat)+1
        txt = txt.sub(/评论：/,"#{floor}:")
        gchat.set(:txt, txt)
      rescue
        next
      end
    end
  end

  def self.redis_to_del
    $redis.keys("RoomMsgDel*").each do |r|
      gchat = Gchat.where({mid: r}).first
      unless gchat.nil?
        gchat.set(:del, true)
      end
      $redis.del(r)
    end
  end

end

