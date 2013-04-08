# coding: utf-8
#黑名单

class UserBlack
  include Mongoid::Document
  
  field :uid, type: Moped::BSON::ObjectId #举报人
  field :bid, type: Moped::BSON::ObjectId  #被拉黑人
  field :report, type:Integer #1代表举报，需要脸脸的工作人员处理
  field :flag,type: Boolean ,default:false #代表是否已处理

  index({ uid: 1 })
  index({ report: 1, flag: 1 })
  

  def user
    User.find_by_id(self.uid)
  end

  

end
