# coding: utf-8

class CommentName
  include Mongoid::Document
  field :_id, type: Moped::BSON::ObjectId
  field :v, type: Array # [{id:id, s:name}]
  
  def self.save_name(uid, tid, name)
    hash = { id:tid, s:name }
    cn = CommentName.find_by_id(uid)
    if cn
      cn.push(:v, hash)
    else
      cn = CommentName.new
      cn._id = uid
      cn.v = [hash]
      cn.save!
    end
    cn
  end



end

