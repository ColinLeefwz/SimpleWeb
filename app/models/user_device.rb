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

end
