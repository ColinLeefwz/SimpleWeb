# encoding: utf-8
#签约商家合同

class ShopSign
  include Mongoid::Document
  field :htid #合同编号
  field :name #商家名称
  field :sid, type:Integer #对应的脸脸商家id，如果有多家店，对应到主店
  field :attch #附件
  delegate :_id, :name, :to => :shop, :prefix => true, :allow_nil => true

  mount_uploader(:attch, ShopSignUploader)

  validates_presence_of :htid, :name, :sid
  validates_uniqueness_of :htid, :sid


  def private_bucket_url(seconds = 30)
    return if (au = self.attch.url).nil?
    #    au = "http://oss.aliyuncs.com/lianlian/516e50b520f318d4ea000001/0.doc"
    uri = URI.parse(au)
    ite = Time.now.to_i+seconds
    signature = `cd oss && python OssSignature.py "#{ENV['ALIYUN_ACCESS_KEY']}" "GET\n\n\n#{ite}\n#{uri.path}"`
    "#{au}?OSSAccessKeyId=#{ENV['ALIYUN_ACCESS_ID']}&Expires=#{ite}&Signature=#{signature.chomp}"
  end

  def shop
    Shop.find_by_id(sid)
  end

end
