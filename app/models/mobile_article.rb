# coding: utf-8

class MobileArticle

  include Mongoid::Document
  store_in({:database => "mweb_production"}) if Rails.env.production?   
  store_in({:database => "mweb_development"}) if Rails.env.development?

  field :sid, type: Integer
  field :title
  field :text #简单摘要
  field :img

  field :category
  field :category2

  field :slide #幻灯片tag

  field :content

  field :kw #关键字

  field :od, type:Float #排序值

  field :show, type: Boolean, default:false

  scope :by_sid, ->(sid){where(sid: sid)}

  scope :by_category, ->(category){where(category: category)}

  scope :desc, ->(col="_id"){order_by(col => -1)}

  def  img_url(type=nil)
    return "http://dface.img.aliyuncs.com/#{id}/0.jpg" if type.nil?
    "http://dface.img.aliyuncs.com/#{id}/#{type}_0.jpg@100w_100h_1e_1c_80Q.jpg"
  end

  #对外的连接
  def mobile_url
    "#{Host::Mweb}/mobile_articles/show?id=#{id}&sid=#{sid}"
  end

end
