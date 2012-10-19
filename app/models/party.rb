# coding: utf-8

class Party
  include Mongoid::Document
  field :name
  field :ftime #起止时间，精确到分钟
  field :etime
  field :sid	#该活动对应的商家id
  field :rsid	#该活动的地点位于那个商家

  def shop
  	Shop.find(sid)
  end

  def rshop
  	Shop.find(rsid)
  end

  def gen_shop
  	s = rshop
  	s.id = Shop.count+2
  	s.name = name
  	s.type = 0
  	s.del = true
  	s.save
  	s
  end

  def Party.save(party)
  	sp = party.gen_shop
  	party.sid = sp.id
  	party.save
  end


end

