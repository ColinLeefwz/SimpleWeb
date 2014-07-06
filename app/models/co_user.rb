# coding: utf-8

class CoUser
  include Mongoid::Document
  field :type
  field :name

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :weibo_home,:head_logo_id, :wb_uid, :show_gender, :to => :user
  end

  def user
    User.find_by_id(_id)
  end

end

