# coding: utf-8
#管理员后台权限

class Right
  include Mongoid::Document
  field :_id, type: Moped::BSON::ObjectId #管理员
  field :data, type: Array # [ {c:'controller_name',r:readonly?} , ... ]
  
  def self.check(controller_name,action_name, admin_id)
    admin = Admin.find_by_id(admin_id)
    return false if admin.nil?
    return true if admin.name=='root'
    right = Right.find_by_id(admin.id)
    return false if right.nil?
    xin = right.data.find {|x| x["c"]=='*'}
    if xin
      if xin["r"]
        return true if read_op(action_name)
      else
        return true
      end
    end
    hash = right.data.find {|x| x["c"]==controller_name}
    return false if hash.nil?
    return true unless hash["r"]
    return read_op(action_name)
  end
  
  def self.read_op(action_name)
    action_name=="show" || action_name=="index" || action_name=="search" || action_name=="list" || action_name=="chat" || action_name=="prompt" || action_name=="warn" || action_name=="kill2"
  end

  #相应控制器的操作权限
  def self.controller_right(right, controller_name)
    con = right.data.find{|f| f['c'] == controller_name}
    return 'none' if con.nil?
    return "r" if con['r']
    return 'w'
  end



  def admin
    Admin.find_by_id(self._id)
  end

end
