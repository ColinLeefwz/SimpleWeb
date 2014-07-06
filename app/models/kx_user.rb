# coding: utf-8

class KxUser
  include Mongoid::Document
  field :type
  field :name

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :weibo_home,:head_logo_id, :wb_uid, :show_gender, :to => :user
  end

  def user
    User.find_by_id(_id)
  end


  def self.init_kxs
    $kxs.each do |kx|
      kxuser= new(type: '脸脸')
      kxuser._id = kx
      kxuser.save
    end
  end

  def self.init_qb_seller
    [
      { :id => "517ccc0ac90d8b49ef000033", "type" => '企博'}, #兵临城下
      {  :id => "516bc8cbc90d8b5663000019", "type" => '企博'}, #兵临城下
      { :id => "50dc0d25c90d8bc42a000098", "type" => '企博'}, #若博斯
      {   :id =>  "519084ddc90d8bc2ee00002c", "type" => '企博'}, #蓶ーDéィ衣賴
      {   :id =>  "50fde347c90d8b8b7f0000d1", "type" => '企博'}, #muak-婷
      {   :id =>  "5170d235c90d8b07e8000052",  "type" => '企博'},#游源土人
      {   :id =>  "50f8e2ebc90d8bb4260000aa",  "type" => '企博'},#大安
      {   :id =>  "519987b0c90d8bdb32000072", "type" => '脸脸'}, #油条
      {  :id => "512b60bec90d8b401e000135",  "type" => '企博'}#3+
    ].each do |kx|
      kxuser= new(type: kx['type'])
      kxuser._id = kx[:id]
      kxuser.save
    end
  end

  def self.init_majia
    # 球球爱嘟嘴,_凯文,甜可儿,Darcy先森,简小二 
    ["513ed1e7c90d8b590100016f","513e8f16c90d8b9f7d0002be","514190f8c90d8bc67b00054a",
      "513e9311c90d8b0b0a000348","51427b92c90d8b670c00027b"].each do |kx|
      kxuser= new(type: '马甲')
      kxuser._id = kx
      kxuser.save
    end
  end

  def self.init_kx_users_redis
    init_kxs
    init_qb_seller
    init_majia
    all.each{|ku| $redis.sadd("KxUsers", ku.id)}
  end

end

