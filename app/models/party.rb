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
  	s.id = Shop.count+2
  	s.name = name
  	s.t = 0
  	s.del = 1
    s.save ? s : nil
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
    {0 => "未开始", 1 => '活动中', 2 => '已过期'  }[flag]
  end

  def Party.save(party)
    return false if party.etime <= party.ftime
  	sp = party.gen_shop
    if sp
      party.sid = sp.id
      party.save
    else
      false
    end
  end

end

