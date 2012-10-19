module InvokeParty
  def self.invoke(time)
    ftime = time.strftime("%Y-%m-%d %H:%M")
    etime = (time - 1.minutes).strftime("%Y-%m-%d %H:%M")
    activate(ftime)
    shut(etime)
  end

  def self.activate(ftime)
    Party.where({ftime: ftime}).each do |party|
      s = party.shop
      s.unset(:del)
    end
  end

  def self.shut(etime)
    Party.where({etime: etime}).each do |party|
      s = party.shop
      s.del = 1
      s.save
    end
  end

end

InvokeParty.invoke(Time.now)

City.create({})