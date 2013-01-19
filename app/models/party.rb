# coding: utf-8

class Party
  include Mongoid::Document
  field :name
  field :ftime #起止时间，精确到分钟
  field :etime
  field :sid	#该活动对应的商家id
  field :rsid	#该活动的地点位于那个商家  
  
  def cat
    (Time.at self._id.to_s[0,8].to_i(16)).strftime("%Y-%m-%d %H:%M:%S")
  end

  def shop
  	Shop.find_by_id(sid)
  end

  def rshop
  	Shop.find_by_id(rsid)
  end

  def gen_shop
  	s = rshop.clone
  	s.id = Shop.next_id
  	s.name = name
  	s.t = 0
  	ftime <= Time.now.strftime("%Y-%m-%d %H:%M")? s.del=nil : s.del = 1
    s.save!
    s
  end

  def flag
    time = Time.now.strftime("%Y-%m-%d %H:%M")
    if time < self.ftime
      0
    elsif time.between?(self.ftime, self.etime)
      1
    elsif time > self.ftime
      2
    end
  end

  def show_flag
    ["未开始", '活动中', '已过期'][flag]
  end
  
  def expire
    self.shop.set(:del,1)
    self.etime = Time.now.strftime('%Y-%m-%d %H:%M')
    self.save
  end

  def Party.save(party)
  	sp = party.gen_shop
    party.sid = sp.id
    party.save!
  end
  
  
  
  def self.activate(ftime)
    Party.where({ftime: ftime}).each do |party|
      s = party.shop
      s.unset(:del)
    end
  end

  def self.deactivate(etime)
    Party.where({etime: etime}).each do |party|
      s = party.shop
      s.del = 1
      s.save
    end
  end
  
  def self.activate_all(ftime)
    Party.where({"ftime" => {"$lt" => ftime}}).each do |party|
      s = party.shop
      s.unset(:del) if s.del
    end
  end

  def self.deactivate_all(etime)
    Party.where({"etime" => {"$lt" => etime}}).each do |party|
      s = party.shop
      s.del = 1
      s.save
    end
  end
  
  def self.scan(time)
    ftime = time.strftime("%Y-%m-%d %H:%M")
    etime = (time - 1.minutes).strftime("%Y-%m-%d %H:%M")
    activate(ftime)
    deactivate(etime)

  end
  
  def self.scan_now
    Party.scan(Time.now)
  end

end

