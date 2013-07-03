# coding: utf-8
#用户设备

class UserDevice
  include Mongoid::Document
  field :_id, type: Moped::BSON::ObjectId
  field :ds, type: Array # [ [mac,os,model,ver,w,h] , ... ]

  def self.init(mac,os,model,ver,w=nil,h=nil)
    ud = UserDevice.new
    if w
      ud.ds = [ [mac,os,model,ver,w,h] ]
    else
      ud.ds = [ [mac,os,model,ver] ]
    end
    ud
  end
  
  def save_to(uid)
    ud = UserDevice.find_by_id(uid)
    if ud.nil?
      self._id = uid
      self.save
      UserDevice.update_redis(uid, self.os_type, self.ds[0][3])
    else
      ud.ds.each do |dev|
        return if dev[0] == self.ds[0][0]
      end
      ud.push(:ds,self.ds[0])
      UserDevice.update_redis(uid, self.os_type, self.ds[0][3])
    end
  end
  
  def UserDevice.update_redis(uid,os,ver)
    $redis.hmset("UF#{uid}", :os, os, :ver, ver )
  end
  
  def UserDevice.user_ver_redis(uid)
    $redis.hget("UF#{uid}", "ver")
  end
  
  def UserDevice.user_os_redis(uid)
    $redis.hget("UF#{uid}", "os")
  end  
  
  def UserDevice.init_redis
    UserDevice.all.each do |ud|
      UserDevice.update_redis(ud._id, ud.os_type, ud.ds[0][3])
    end
  end
  
  def os_type
    UserDevice.os_type(self.ds[0][1])
  end
  
  def self.os_type(os)
    return 0 if os.nil?
    case os[0,3].downcase
    when "and"
      1
    when "ios"
      2
    else
      0
    end
  end

end
