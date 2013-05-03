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
    else
      ud.ds.each do |dev|
        return if dev[0] == self.ds[0][0]
      end
      ud.push(:ds,self.ds[0])
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
