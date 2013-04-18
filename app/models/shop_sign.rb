# encoding: utf-8
#签约商家合同

class ShopSign
  include Mongoid::Document
  field :htid #合同编号
  field :name #商家名称
  field :sid, type:Integer #对应的脸脸商家id，如果有多家店，对应到主店
  field :attch #附件
  ALIYUN_ACCESS_ID="ACS4wSgMTzClBisY"
  ALIYUN_ACCESS_KEY="5e4VzNCmHz"
  
  mount_uploader(:attch, ShopSignUploader)

  validates_presence_of :htid, :name
  validates_uniqueness_of :htid, :sid


  def private_bucket_url(seconds = 30)
    return if (au = self.attch.url).nil?
    #    au = "http://oss.aliyuncs.com/lianlian/516e50b520f318d4ea000001/0.doc"
    uri = URI.parse(au)
    ite = Time.now.to_i+seconds
    signature = `cd oss && python OssSignature.py "#{ALIYUN_ACCESS_KEY}" "GET\n\n\n#{ite}\n#{uri.path}"`
    "#{au}?OSSAccessKeyId=#{ALIYUN_ACCESS_ID}&Expires=#{ite}&Signature=#{signature.chomp}"
  end

end
