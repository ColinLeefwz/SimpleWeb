# coding: utf-8
require 'rest_client'

class Rekognition
  include Mongoid::Document
  field :data, type: Hash
  field :data2, type: Hash

  #<Rekognition _id: 502e6303421aa918ba000001, data: {"boundingbox"=>{"tl"=>{"x"=>99.23, "y"=>140.77}, "size"=>{"width"=>375.38, "height"=>375.38}}, "confidence"=>1, "eye_left"=>{"x"=>209.6, "y"=>281.2}, "eye_right"=>{"x"=>365.8, "y"=>263.2}, "nose"=>{"x"=>299.7, "y"=>365.3}, "mouth l"=>{"x"=>251.7, "y"=>449.3}, "mouth_l"=>{"x"=>251.7, "y"=>449.3}, "mouth r"=>{"x"=>371.8, "y"=>449.3}, "mouth_r"=>{"x"=>371.8, "y"=>449.3}, "age"=>26.55, "smile"=>0, "glasses"=>0.39, "eye_closed"=>0.68, "sex"=>0.38}, data2: nil> 


  def self.gen_by_user(user)
    gen(user.id, user.head_logo.img.url)
  end
  
  def self.gen(uid,url)
    begin
      info = RestClient.get "http://rekognition.com/func/api/?api_key=D5cT1o17dos5Qo9n&api_secret=H2V77hSyHhelJNzz&jobs=face_gender_emotion_age_glass_aggressive&urls=#{url}"
      ret = ActiveSupport::JSON.decode(info)
      if ret && ret["face_detection"]
        arr = ret["face_detection"]
        rek = Rekognition.new
        rek.id = uid
        rek.data = arr[0]
        rek.data2 = arr[1] if arr.size>1
        rek.save!
      end
    rescue Exception => e
      puts e
    end
  end
  
  def self.init
    User.where({auto:{"$ne" => true}}).sort({_id:1}).each do |user|
      next if user.head_logo_id.nil?
      next if Rekognition.find_by_id(user.id)
      gen(user.id, UserLogo.img_url(user.head_logo_id))
      sleep 5
    end
  end


  def user
    @user ||= User.find_by_id(_id)
  end

end

