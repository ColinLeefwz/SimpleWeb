# encoding: utf-8
# 备份session_id －> user_id的映射关系

class SessionUser
  include Mongoid::Document
  field :_id, type:String #session_id
  field :uid, type: Moped::BSON::ObjectId
  field :cat, type:Integer

end
