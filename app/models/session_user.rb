# encoding: utf-8
# 备份session_id －> user_id的映射关系

class SessionUser
  include Mongoid::Document
  field :_id, type:String #session_id
  field :uid, type: Moped::BSON::ObjectId
  field :cat, type:Integer
  
  def user
    User.find_by_id(self.uid)
  end
  
  def cats
    return unless self.cat
    (Time.at self.cat).strftime("%Y-%m-%d %H:%M:%S")
  end

end
