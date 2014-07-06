# coding: utf-8

class Version
  include Mongoid::Document
  field :_id, type: String
  field :desc #版本功能描写
  field :upgrade, type:Boolean #版本是否强制升级

  def show_upgrage
    self.upgrade ? '是' : "否"
  end
 
end
